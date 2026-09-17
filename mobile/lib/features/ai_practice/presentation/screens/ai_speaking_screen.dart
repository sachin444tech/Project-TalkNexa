import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_conversation_context.dart';
import 'package:mobile/features/ai_practice/domain/models/chat_message.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_metrics.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_state.dart';
import 'package:mobile/features/ai_practice/domain/services/ai_conversation_service.dart';
import 'package:mobile/features/ai_practice/domain/services/microphone_service.dart';
import 'package:mobile/features/ai_practice/domain/services/speech_recognition_service.dart';
import 'package:mobile/features/ai_practice/domain/services/text_to_speech_service.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/ai_partner_avatar.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/chat_message_bubble.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/mic_control.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/session_summary_card.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_response.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_feedback.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/ai_feedback_card.dart';
import 'package:mobile/features/ai_practice/domain/services/ai_voice_selector.dart';

class AiSpeakingScreen extends StatefulWidget {
  final String scenario;
  final String difficulty;
  final int duration;

  const AiSpeakingScreen({
    super.key,
    required this.scenario,
    required this.difficulty,
    required this.duration,
  });

  @override
  State<AiSpeakingScreen> createState() => _AiSpeakingScreenState();
}

class _AiSpeakingScreenState extends State<AiSpeakingScreen> {
  SpeakingState _speakingState = SpeakingState.idle;

  final MicrophoneService _microphoneService = MicrophoneService();

  final SpeechRecognitionService _speechRecognitionService =
      SpeechRecognitionService();

  final AiConversationService _aiConversationService = AiConversationService();

  TextToSpeechService? _textToSpeechService;

  final AiVoiceSelector _aiVoiceSelector = const AiVoiceSelector();

  final List<ChatMessage> _messages = [];

  int _spokenTurnCount = 0;
  int _spokenWordCount = 0;
  int _correctedTurnCount = 0;
  double? _finalSessionScore;
  SpeakingSessionMetrics? _finalSessionMetrics;

  SpeakingSessionMetrics get _sessionMetrics {
    final totalDurationSeconds = widget.duration * 60;
    final elapsedSeconds = totalDurationSeconds - _remainingSeconds;

    return SpeakingSessionMetrics(
      spokenTurnCount: _spokenTurnCount,
      spokenWordCount: _spokenWordCount,
      correctedTurnCount: _correctedTurnCount,
      durationSeconds: elapsedSeconds.clamp(0, totalDurationSeconds),
    );
  }

  AiFeedback? _latestFeedback;

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  late int _remainingSeconds;

  int _speechGeneration = 0;

  bool _voiceReady = false;
  bool _isProcessingResponse = false;
  bool _sessionEnded = false;
  bool _isScreenActive = true;

  String? _lastFailedUserMessage;

  void _handleSpeechResult(String text, bool isFinal) {
    if (!mounted ||
        !_isScreenActive ||
        _sessionEnded ||
        _isProcessingResponse) {
      return;
    }

    if (text.trim().isEmpty) {
      return;
    }

    if (!isFinal) {
      return;
    }

    if (_isProcessingResponse) {
      return;
    }

    _addUserMessage(text);
  }

  void _addUserMessage(String text) {
    if (!mounted || !_isScreenActive || _sessionEnded) return;

    final conversationHistory = _buildConversationHistory();

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          sender: MessageSender.user,
          source: MessageSource.speech,
          timestamp: DateTime.now(),
        ),
      );

      _spokenTurnCount++;
      _spokenWordCount += text.trim().split(RegExp(r'\s+')).length;

      _latestFeedback = null;
      _speakingState = SpeakingState.processing;
    });

    _scrollToLatestMessage();

    _processUserMessage(text, conversationHistory);
  }

  List<Map<String, String>> _buildConversationHistory() {
    const maxHistoryMessages = 12;

    final recentMessages = _messages.length <= maxHistoryMessages
        ? _messages
        : _messages.sublist(_messages.length - maxHistoryMessages);

    return recentMessages.map((message) {
      final role = switch (message.source) {
        MessageSource.ai => 'assistant',
        MessageSource.speech => 'user',
        MessageSource.text => 'user',
      };

      return {'role': role, 'text': message.text};
    }).toList();
  }

  Future<void> _processUserMessage(
    String userText,
    List<Map<String, String>> conversationHistory,
  ) async {
    if (!mounted || !_isScreenActive) return;

    if (_isProcessingResponse) return;

    _isProcessingResponse = true;

    setState(() {
      _speakingState = SpeakingState.processing;
    });

    try {
      final context = AiConversationContext(
        scenario: widget.scenario,
        difficulty: widget.difficulty,
        userLevel: 'Intermediate',
      );

      final requestGeneration = ++_speechGeneration;

      final AiResponse response = await _aiConversationService.generateResponse(
        userMessage: userText,
        context: context,
        conversationHistory: conversationHistory,
      );

      if (!mounted || !_isScreenActive || _sessionEnded) {
        _isProcessingResponse = false;
        return;
      }

      if (requestGeneration != _speechGeneration) {
        _isProcessingResponse = false;
        return;
      }

      if (!mounted || !_isScreenActive || _sessionEnded) {
        return;
      }

      final speechGeneration = requestGeneration;

      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: response.response,
            sender: MessageSender.ai,
            source: MessageSource.ai,
            timestamp: DateTime.now(),
          ),
        );

        _lastFailedUserMessage = null;

        _latestFeedback = response.feedback;

        if (response.feedback.hasCorrection) {
          _correctedTurnCount++;
        }

        _speakingState = SpeakingState.aiSpeaking;
      });

      try {
        await _textToSpeechService!.speak(response.response);
      } catch (e) {
        _recoverToIdle();
        return;
      }

      if (!mounted || !_isScreenActive || _sessionEnded) {
        return;
      }

      if (speechGeneration != _speechGeneration) {
        return;
      }

      if (!mounted || !_isScreenActive) return;

      _scrollToLatestMessage();

      setState(() {
        _speakingState = SpeakingState.idle;
      });
    } catch (e) {
      if (!mounted || !_isScreenActive) return;

      _lastFailedUserMessage = userText;

      _recoverToIdle();
      _showAiError();
    } finally {
      _isProcessingResponse = false;
    }
  }

  void _scrollToLatestMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _initializeServices() async {
    if (!_isScreenActive || _sessionEnded) return;

    try {
      final voiceProfile = _aiVoiceSelector.select(
        scenario: widget.scenario,
        difficulty: widget.difficulty,
      );

      debugPrint('TalkNexa AI voice profile: ${voiceProfile.name}');

      _textToSpeechService = TextToSpeechService(config: voiceProfile.config);

      await _textToSpeechService!.initialize();

      if (!mounted) return;

      setState(() {
        _voiceReady = true;
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.duration * 60;

    _addInitialMessage();

    _startTimer();

    _initializeServices();
  }

  void _addInitialMessage() {
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _getOpeningMessage(),
        sender: MessageSender.ai,
        source: MessageSource.ai,
        timestamp: DateTime.now(),
      ),
    );
  }

  String _getOpeningMessage() {
    switch (widget.scenario) {
      case 'Job Interview':
        return 'Hi! Welcome to your interview practice. Tell me a little about yourself.';

      case 'Travel':
        return 'Welcome! Let us practice a travel conversation. Imagine you are checking into a hotel.';

      case 'College':
        return 'Hey! Let us practice a college conversation. Tell me about your favorite subject.';

      case 'Daily Life':
        return 'Hello! Let us talk about your daily routine. What does a typical day look like for you?';

      case 'Role Play':
        return 'Welcome to role play! I will create a realistic situation for you. Are you ready?';

      default:
        return 'Hi! I am your TalkNexa AI speaking partner. Tell me something interesting about your day.';
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_isScreenActive || _sessionEnded) return;

      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _endSession();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;

    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleMic() async {
    if (!_isScreenActive || _sessionEnded) return;

    if (!_voiceReady) {
      return;
    }
    if (_speakingState == SpeakingState.aiSpeaking) {
      _speechGeneration++;

      await _textToSpeechService!.interrupt();

      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.idle;
      });

      _speechGeneration++;
      await _startListening();
      return;
    }

    if (_speakingState == SpeakingState.idle) {
      await _startListening();
      return;
    }

    if (_speakingState == SpeakingState.listening) {
      await _stopListening();
    }
  }

  Future<void> _startListening() async {
    if (!_isScreenActive || _sessionEnded) return;

    try {
      final available = await _speechRecognitionService.initialize();

      if (!available) {
        _showSpeechRecognitionError();
        return;
      }

      final started = await _speechRecognitionService.startListening(
        onResult: _handleSpeechResult,
      );

      if (!started) {
        _showSpeechRecognitionError();
        return;
      }

      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.listening;
      });
    } catch (e) {
      _recoverToIdle();
      _showSpeechRecognitionError();
    }
  }

  Future<void> _stopListening() async {
    if (!_isScreenActive || _sessionEnded) return;

    try {
      await _speechRecognitionService.stopListening();

      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.processing;
      });
    } catch (e) {
      _recoverToIdle();
      _showSpeechRecognitionError();
    }
  }

  void _showSpeechRecognitionError() {
    if (!mounted || !_isScreenActive || _sessionEnded) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Speech recognition is not available. '
          'Please check your microphone and speech settings.',
        ),
      ),
    );
  }

  void _recoverToIdle() {
    if (!mounted || !_isScreenActive || _sessionEnded) return;

    _isProcessingResponse = false;

    setState(() {
      _speakingState = SpeakingState.idle;
    });
  }

  void _showAiError() {
    if (!mounted || !_isScreenActive || _sessionEnded) return;

    if (_lastFailedUserMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong while generating the AI response.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Something went wrong while generating the AI response.',
        ),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            if (!_isScreenActive || _sessionEnded || _isProcessingResponse) {
              return;
            }

            final failedMessage = _lastFailedUserMessage;

            if (failedMessage == null) return;

            _lastFailedUserMessage = null;

            final conversationHistory = _buildConversationHistory();

            _processUserMessage(failedMessage, conversationHistory);
          },
        ),
      ),
    );
  }

  Future<void> _endSession() async {
    if (_sessionEnded) return;

    _timer?.cancel();

    final sessionMetrics = _sessionMetrics;
    final sessionScore = sessionMetrics.accuracyScore;

    _finalSessionMetrics = sessionMetrics;
    _finalSessionScore = sessionScore;

    debugPrint(
      'TalkNexa session metrics: '
      'turns=${sessionMetrics.spokenTurnCount}, '
      'words=${sessionMetrics.spokenWordCount}, '
      'corrected=${sessionMetrics.correctedTurnCount}, '
      'duration=${sessionMetrics.durationSeconds}s, '
      'score=${sessionScore.toStringAsFixed(1)}',
    );

    _speechGeneration++;
    _sessionEnded = true;
    _isProcessingResponse = false;

    try {
      await _speechRecognitionService.stopListening();
    } catch (e) {
      debugPrint('Speech recognition cleanup failed: $e');
    }

    await _textToSpeechService?.interrupt();

    if (!mounted || !_isScreenActive) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final metrics = _finalSessionMetrics;
        
        if (metrics == null) {
          return const AlertDialog(
            title: Text('Session Complete 🎉'),
            content: Text('Your speaking session has ended.'),
      );
    }

    return AlertDialog(
      title: const Text(
        'Session Complete 🎉',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: SessionSummaryCard(
            metrics: metrics,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ],
    );
  },
);
}

  @override
  void dispose() {
    _isScreenActive = false;

    _timer?.cancel();
    _scrollController.dispose();
    _microphoneService.dispose();
    _speechRecognitionService.dispose();
    _textToSpeechService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: _endSession,
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Column(
          children: [
            Text(
              'TalkNexa AI',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 2),
            Text(
              'Speaking Partner',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formattedTime,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const AiPartnerAvatar(),

            const SizedBox(height: 10),

            Text(
              widget.scenario,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                physics: const BouncingScrollPhysics(),
                itemCount:
                    _messages.length +
                    (_latestFeedback != null && _latestFeedback!.hasCorrection
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    return ChatMessageBubble(message: _messages[index]);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AiFeedbackCard(feedback: _latestFeedback!),
                  );
                },
              ),
            ),

            if (!_voiceReady)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Preparing your AI speaking partner...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            if (_speakingState == SpeakingState.aiSpeaking)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'TalkNexa AI is speaking...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MicControl(state: _speakingState, onTap: _handleMic),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _endSession,
                    child: const Text(
                      'End Session',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

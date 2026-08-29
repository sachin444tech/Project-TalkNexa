import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_conversation_context.dart';
import 'package:mobile/features/ai_practice/domain/models/chat_message.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_state.dart';
import 'package:mobile/features/ai_practice/domain/services/ai_conversation_service.dart';
import 'package:mobile/features/ai_practice/domain/services/microphone_service.dart';
import 'package:mobile/features/ai_practice/domain/services/speech_recognition_service.dart';
import 'package:mobile/features/ai_practice/domain/services/text_to_speech_service.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/ai_partner_avatar.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/chat_message_bubble.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/mic_control.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_response.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/ai_feedback_card.dart';

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

  final TextToSpeechService _textToSpeechService = TextToSpeechService();

  final List<ChatMessage> _messages = [];

  AiFeedback? _latestFeedback;

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  late int _remainingSeconds;

  int _speechGeneration = 0;

  void _handleSpeechResult(String text, bool isFinal) {
    if (!mounted) return;

    if (text.trim().isEmpty) {
      return;
    }

    if (!isFinal) {
      return;
    }

    _addUserMessage(text);
  }

  void _addUserMessage(String text) {
    final conversationHistory = _buildConversationHistory();

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          sender: MessageSender.user,
          timestamp: DateTime.now(),
        ),
      );

      _latestFeedback = null;
      _speakingState = SpeakingState.processing;
    });

    _scrollToLatestMessage();

    _processUserMessage(text, conversationHistory);
  }

  List<Map<String, String>> _buildConversationHistory() {
    return _messages.map((message) {
      return {
        'role': message.isUser ? 'user' : 'assistant',
        'text': message.text,
      };
    }).toList();
  }

  Future<void> _processUserMessage(
    String userText,
    List<Map<String, String>> conversationHistory,
  ) async {
    if (!mounted) return;

    setState(() {
      _speakingState = SpeakingState.processing;
    });

    try {
      final context = AiConversationContext(
        scenario: widget.scenario,
        difficulty: widget.difficulty,
        userLevel: 'Intermediate',
      );

      final AiResponse response = await _aiConversationService.generateResponse(
        userMessage: userText,
        context: context,
        conversationHistory: conversationHistory,
      );

      if (!mounted) return;

      final speechGeneration = ++_speechGeneration;

      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: response.response,
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
          ),
        );

        _latestFeedback = response.feedback;

        _speakingState = SpeakingState.aiSpeaking;
      });

      await _textToSpeechService.speak(response.response);

      if (!mounted) return;

      if (speechGeneration != _speechGeneration) {
        return;
      }

      _scrollToLatestMessage();

      setState(() {
        _speakingState = SpeakingState.idle;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.idle;
      });

      _showAiError();
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
    try {
      await _textToSpeechService.initialize();

      if (!mounted) return;
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
      if (!mounted) return;

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
    if (_speakingState == SpeakingState.aiSpeaking) {
      _speechGeneration++;

      await _textToSpeechService.interrupt();

      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.idle;
      });

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
      if (!mounted) return;

      _showSpeechRecognitionError();
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechRecognitionService.stopListening();

      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.processing;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _speakingState = SpeakingState.idle;
      });

      _showSpeechRecognitionError();
    }
  }

  void _showSpeechRecognitionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Speech recognition is not available. '
          'Please check your microphone and speech settings.',
        ),
      ),
    );
  }

  void _showAiError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong while generating the AI response.'),
      ),
    );
  }

  Future<void> _endSession() async {
    _timer?.cancel();

    _speechGeneration++;

    await _textToSpeechService.interrupt();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Session Complete 🎉'),
          content: const Text('Great job! Your speaking session has ended.'),
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
    _timer?.cancel();
    _scrollController.dispose();
    _microphoneService.dispose();
    _speechRecognitionService.dispose();
    _textToSpeechService.dispose();
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

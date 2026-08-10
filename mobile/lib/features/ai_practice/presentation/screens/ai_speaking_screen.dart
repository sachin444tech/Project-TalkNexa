import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/app/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/speaking_state.dart';
import '../widgets/ai_partner_avatar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/mic_control.dart';

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
  State<AiSpeakingScreen> createState() =>
      _AiSpeakingScreenState();
}

class _AiSpeakingScreenState
    extends State<AiSpeakingScreen> {
  SpeakingState _speakingState =
      SpeakingState.idle;

  final List<ChatMessage> _messages = [];

  Timer? _timer;

  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.duration * 60;

    _addInitialMessage();

    _startTimer();
  }

  void _addInitialMessage() {
    _messages.add(
      ChatMessage(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
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
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _endSession();
          return;
        }

        setState(() {
          _remainingSeconds--;
        });
      },
    );
  }

  String get _formattedTime {
    final minutes =
        _remainingSeconds ~/ 60;

    final seconds =
        _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _handleMic() {
    if (_speakingState ==
        SpeakingState.idle) {
      _startListening();
    } else if (_speakingState ==
        SpeakingState.listening) {
      _stopListening();
    }
  }

  void _startListening() {
    setState(() {
      _speakingState =
          SpeakingState.listening;
    });
  }

  void _stopListening() {
    setState(() {
      _speakingState =
          SpeakingState.processing;
    });

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        _addSimulatedConversation();

        setState(() {
          _speakingState =
              SpeakingState.aiSpeaking;
        });

        Future.delayed(
          const Duration(seconds: 2),
          () {
            if (!mounted) return;

            setState(() {
              _speakingState =
                  SpeakingState.idle;
            });
          },
        );
      },
    );
  }

  void _addSimulatedConversation() {
    _messages.add(
      ChatMessage(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        text:
            'I would like to tell you about my day.',
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      ),
    );

    _messages.add(
      ChatMessage(
        id: (DateTime.now()
                    .millisecondsSinceEpoch +
                1)
            .toString(),
        text:
            'That sounds interesting! Tell me more. What was the best part of your day?',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _endSession() {
    _timer?.cancel();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Session Complete 🎉',
          ),
          content: const Text(
            'Great job! Your speaking session has ended.',
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
    _timer?.cancel();
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
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
        title: const Column(
          children: [
            Text(
              'TalkNexa AI',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Speaking Partner',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(20),
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
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                physics:
                    const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return ChatMessageBubble(
                    message: _messages[index],
                  );
                },
              ),
            ),

            if (_speakingState ==
                SpeakingState.aiSpeaking)
              const Padding(
                padding:
                    EdgeInsets.only(bottom: 8),
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
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                22,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MicControl(
                    state: _speakingState,
                    onTap: _handleMic,
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _endSession,
                    child: const Text(
                      'End Session',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight:
                            FontWeight.w700,
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
import 'package:flutter/material.dart';


import 'package:mobile/app/theme/app_colors.dart';
import '../../domain/models/speaking_state.dart';

class MicControl extends StatelessWidget {
  final SpeakingState state;
  final VoidCallback onTap;

  const MicControl({
    super.key,
    required this.state,
    required this.onTap,
  });

  bool get isListening =>
      state == SpeakingState.listening;

  bool get isProcessing =>
      state == SpeakingState.processing;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;

    if (isListening) {
      backgroundColor = AppColors.error;
    } else if (isProcessing) {
      backgroundColor = AppColors.secondary;
    } else {
      backgroundColor = AppColors.primary;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: isProcessing ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            width: isListening ? 82 : 72,
            height: isListening ? 82 : 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: isProcessing
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      isListening
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          isListening
              ? 'Listening...'
              : isProcessing
                  ? 'Thinking...'
                  : 'Tap to speak',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
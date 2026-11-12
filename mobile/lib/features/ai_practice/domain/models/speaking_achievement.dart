
import 'package:flutter/material.dart';

class SpeakingAchievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int target;
  final int currentProgress;

  const SpeakingAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.currentProgress,
  });

  bool get isUnlocked => currentProgress >= target;

  double get progress {
    if (target <= 0) return 0;

    return (currentProgress / target).clamp(0.0, 1.0);
  }
}

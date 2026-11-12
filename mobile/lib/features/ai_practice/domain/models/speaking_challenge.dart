
class SpeakingChallenge {
  final String id;
  final String title;
  final String description;
  final int target;
  final int currentProgress;
  final String unit;

  const SpeakingChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.currentProgress,
    required this.unit,
  });

  bool get isCompleted => currentProgress >= target;

  double get progress {
    if (target <= 0) return 0;

    return (currentProgress / target).clamp(0.0, 1.0);
  }

  int get remaining {
    return (target - currentProgress).clamp(0, target);
  }
}

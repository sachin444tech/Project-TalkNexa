class SpeakingSessionMetrics {
  final int spokenTurnCount;
  final int spokenWordCount;
  final int correctedTurnCount;
  final int durationSeconds;

  const SpeakingSessionMetrics({
    required this.spokenTurnCount,
    required this.spokenWordCount,
    required this.correctedTurnCount,
    required this.durationSeconds,
  });

  double get accuracyScore {
  if (spokenTurnCount == 0) {
    return 0;
  }

  final correctionRate = correctedTurnCount / spokenTurnCount;
  final baseScore = 100 - (correctionRate * 100);

  final participationBonus = spokenTurnCount >= 5 ? 5 : 0;

  return (baseScore + participationBonus).clamp(0, 100);
  }
}
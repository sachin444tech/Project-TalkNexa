
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

  /// Measures participation in a speaking practice session.
  ///
  /// This is NOT an English proficiency or grammar accuracy score.
  /// Maximum score: 100.
  double get practiceScore {
    // Maximum 40 points for speaking turns.
    final turnScore =
        (spokenTurnCount / 10).clamp(0.0, 1.0) * 40;

    // Maximum 40 points for words spoken.
    final wordScore =
        (spokenWordCount / 150).clamp(0.0, 1.0) * 40;

    // Maximum 20 points for session duration.
    final durationScore =
        (durationSeconds / 300).clamp(0.0, 1.0) * 20;

    return (turnScore + wordScore + durationScore)
        .clamp(0.0, 100.0);
  }

  /// Temporary compatibility getter for existing screens and code.
  ///
  /// Use practiceScore in new code.
  @Deprecated('Use practiceScore instead.')
  double get accuracyScore => practiceScore;
}


class ScenarioRecommendation {
  final String scenario;
  final String reason;
  final double averageScore;
  final int sessionCount;

  const ScenarioRecommendation({
    required this.scenario,
    required this.reason,
    required this.averageScore,
    required this.sessionCount,
  });
}

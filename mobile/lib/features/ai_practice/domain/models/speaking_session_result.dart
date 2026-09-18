import 'speaking_session_metrics.dart';

class SpeakingSessionResult {
  final String id;
  final String scenario;
  final String difficulty;
  final SpeakingSessionMetrics metrics;
  final DateTime completedAt;

  const SpeakingSessionResult({
    required this.id,
    required this.scenario,
    required this.difficulty,
    required this.metrics,
    required this.completedAt,
  });
}
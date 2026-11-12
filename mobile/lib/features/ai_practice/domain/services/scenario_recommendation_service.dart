
import 'package:mobile/features/ai_practice/domain/models/scenario_recommendation.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class ScenarioRecommendationService {
  const ScenarioRecommendationService();

  static const List<String> availableScenarios = [
    'Job Interview',
    'Travel',
    'College',
    'Daily Life',
    'Role Play',
  ];

  List<ScenarioRecommendation> generateRecommendations(
    List<SpeakingSessionResult> sessions,
  ) {
    final recommendations = <ScenarioRecommendation>[];

    final groupedSessions = <String, List<SpeakingSessionResult>>{};

    for (final session in sessions) {
      groupedSessions.putIfAbsent(
        session.scenario,
        () => [],
      );

      groupedSessions[session.scenario]!.add(session);
    }

    // First, recommend scenarios the learner has never practised.
    for (final scenario in availableScenarios) {
      if (!groupedSessions.containsKey(scenario)) {
        recommendations.add(
          ScenarioRecommendation(
            scenario: scenario,
            reason: 'You have not practised this scenario yet. Give it a try!',
            averageScore: 0,
            sessionCount: 0,
          ),
        );
      }
    }

    // Next, find the scenario with the lowest average practice score.
    for (final entry in groupedSessions.entries) {
      final scenarioSessions = entry.value;

      final averageScore = scenarioSessions.fold<double>(
            0,
            (total, session) =>
                total + session.metrics.practiceScore,
          ) /
          scenarioSessions.length;

      if (averageScore < 60) {
        recommendations.add(
          ScenarioRecommendation(
            scenario: entry.key,
            reason: 'More practice here can help you build consistency.',
            averageScore: averageScore,
            sessionCount: scenarioSessions.length,
          ),
        );
      }
    }

    // Return the three most useful recommendations.
    return recommendations.take(3).toList();
  }
}

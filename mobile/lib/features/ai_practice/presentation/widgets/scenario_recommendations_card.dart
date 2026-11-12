
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/scenario_recommendation.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/services/scenario_recommendation_service.dart';

class ScenarioRecommendationsCard extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const ScenarioRecommendationsCard({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    const recommendationService = ScenarioRecommendationService();

    final recommendations =
        recommendationService.generateRecommendations(sessions);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Recommended for You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Discover what you should practise next.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),

            if (recommendations.isEmpty)
              const Text(
                'Great work! You are building consistency across all available scenarios.',
                style: TextStyle(fontSize: 14),
              ),

            ...recommendations.map(
              (recommendation) => _RecommendationItem(
                recommendation: recommendation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final ScenarioRecommendation recommendation;

  const _RecommendationItem({
    required this.recommendation,
  });

  IconData _getScenarioIcon(String scenario) {
    switch (scenario.toLowerCase()) {
      case 'job interview':
        return Icons.work_outline_rounded;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'college':
        return Icons.school_outlined;
      case 'daily life':
        return Icons.wb_sunny_outlined;
      case 'role play':
        return Icons.theater_comedy_rounded;
      default:
        return Icons.record_voice_over_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getScenarioIcon(recommendation.scenario),
              color: colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.scenario,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  recommendation.reason,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (recommendation.sessionCount > 0) ...[
                  const SizedBox(height: 7),
                  Text(
                    '${recommendation.sessionCount} sessions • '
                    'Average practice score: '
                    '${recommendation.averageScore.round()}/100',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

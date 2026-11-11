
import 'package:flutter/material.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingProgressInsights extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingProgressInsights({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (sessions.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedSessions = [...sessions]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));

    final scores = sortedSessions
        .map((session) => session.metrics.practiceScore)
        .toList();

    final latestScore = scores.last;

    final bestScore = scores.reduce(
      (a, b) => a > b ? a : b,
    );

    final hasEnoughData = scores.length >= 4;

    String trend = 'Not enough data';
    String insight =
        'Complete at least four speaking sessions to unlock your personalised progress trend.';
    IconData trendIcon = Icons.insights_outlined;
    Color trendColor = theme.colorScheme.primary;

    if (hasEnoughData) {
      final splitIndex = scores.length ~/ 2;

      final earlierScores = scores.sublist(0, splitIndex);
      final recentScores = scores.sublist(splitIndex);

      final earlierAverage = earlierScores.reduce((a, b) => a + b) /
          earlierScores.length;

      final recentAverage = recentScores.reduce((a, b) => a + b) /
          recentScores.length;

      final difference = recentAverage - earlierAverage;

      if (difference >= 5) {
        trend = 'Improving';
        trendIcon = Icons.trending_up;
        trendColor = Colors.green;
        insight =
            'Your recent practice scores are ${difference.toStringAsFixed(1)} points higher on average. Keep up the consistency!';
      } else if (difference <= -5) {
        trend = 'Needs attention';
        trendIcon = Icons.trending_down;
        trendColor = Colors.orange;
        insight =
            'Your recent average is ${difference.abs().toStringAsFixed(1)} points lower. Try shorter, more consistent practice sessions.';
      } else {
        trend = 'Stable';
        trendIcon = Icons.trending_flat;
        trendColor = theme.colorScheme.primary;
        insight =
            'Your performance is staying consistent. Keep practising to build stronger speaking habits.';
      }
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Progress Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _InsightMetric(
                    label: 'Latest score',
                    value: '${latestScore.toStringAsFixed(0)}/100',
                    icon: Icons.flag_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InsightMetric(
                    label: 'Best score',
                    value: '${bestScore.toStringAsFixed(0)}/100',
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: trendColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(trendIcon, color: trendColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trend,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: trendColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          insight,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Based on your Practice Engagement Score, not a formal English proficiency assessment.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InsightMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 21,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

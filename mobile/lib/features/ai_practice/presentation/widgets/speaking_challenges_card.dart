
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/speaking_challenge.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/services/speaking_challenge_service.dart';

class SpeakingChallengesCard extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingChallengesCard({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const challengeService = SpeakingChallengeService();

    final challenges =
        challengeService.calculateChallenges(sessions);

    final completedCount =
        challenges.where((challenge) => challenge.isCompleted).length;

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
                  Icons.flag_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Speaking Challenges',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$completedCount / ${challenges.length}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Complete small goals and build stronger speaking habits.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            ...challenges.map(
              (challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChallengeItem(challenge: challenge),
              ),
            ),
            const SizedBox(height: 4),
            _buildMotivationalMessage(
              context,
              completedCount,
              challenges.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalMessage(
    BuildContext context,
    int completedCount,
    int totalCount,
  ) {
    final theme = Theme.of(context);

    final message = completedCount == totalCount
        ? 'Outstanding! You completed every challenge!'
        : completedCount > 0
            ? 'Great progress! Keep going to complete more challenges.'
            : 'Every great speaker starts with one small step.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeItem extends StatelessWidget {
  final SpeakingChallenge challenge;

  const _ChallengeItem({
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = challenge.isCompleted;

    final progressColor = completed
        ? Colors.green
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed
              ? Colors.green.withValues(alpha: 0.35)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.flag_outlined,
                color: progressColor,
                size: 21,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            challenge.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: challenge.progress,
              minHeight: 7,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                completed
                    ? 'Completed'
                    : '${challenge.remaining} ${challenge.unit} remaining',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${challenge.currentProgress}/${challenge.target}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

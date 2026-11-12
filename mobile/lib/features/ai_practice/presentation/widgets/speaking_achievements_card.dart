
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/speaking_achievement.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/services/speaking_achievement_service.dart';

class SpeakingAchievementsCard extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingAchievementsCard({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const achievementService = SpeakingAchievementService();

    final achievements =
        achievementService.calculateAchievements(sessions);

    final unlockedCount =
        achievements.where((item) => item.isUnlocked).length;

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
                  Icons.workspace_premium_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your Achievements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$unlockedCount / ${achievements.length}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Celebrate every milestone in your speaking journey.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: achievements.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                return _AchievementBadge(
                  achievement: achievements[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final SpeakingAchievement achievement;

  const _AchievementBadge({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = achievement.isUnlocked;

    final badgeColor = unlocked
        ? Colors.amber.shade700
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? Colors.amber.withValues(alpha: 0.45)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeColor.withValues(alpha: 0.12),
            ),
            child: Icon(
              unlocked ? achievement.icon : Icons.lock_outline_rounded,
              color: badgeColor,
              size: 27,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: unlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              achievement.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: achievement.progress,
              minHeight: 5,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                unlocked ? Colors.amber.shade700 : badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            unlocked
                ? 'Unlocked'
                : '${achievement.currentProgress}/${achievement.target}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

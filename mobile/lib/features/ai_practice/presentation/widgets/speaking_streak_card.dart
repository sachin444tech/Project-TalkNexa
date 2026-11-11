import 'package:flutter/material.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingStreakCard extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingStreakCard({
    super.key,
    required this.sessions,
  });

  static const int weeklyGoal = 5;

  int _dateKey(DateTime date) {
    final localDate = date.toLocal();
    return localDate.year * 10000 +
        localDate.month * 100 +
        localDate.day;
  }

  int _getCurrentStreak(Set<int> activeDays) {
    final today = DateTime.now();
    final todayKey = _dateKey(today);
    final yesterdayKey = _dateKey(
      today.subtract(const Duration(days: 1)),
    );

    DateTime currentDay;

    if (activeDays.contains(todayKey)) {
      currentDay = DateTime(today.year, today.month, today.day);
    } else if (activeDays.contains(yesterdayKey)) {
      currentDay = DateTime(today.year, today.month, today.day)
          .subtract(const Duration(days: 1));
    } else {
      return 0;
    }

    int streak = 0;

    while (activeDays.contains(_dateKey(currentDay))) {
      streak++;
      currentDay = currentDay.subtract(const Duration(days: 1));
    }

    return streak;
  }

  int _getLongestStreak(List<int> sortedDays) {
    if (sortedDays.isEmpty) return 0;

    int longest = 1;
    int current = 1;

    for (int i = 1; i < sortedDays.length; i++) {
      final previous = _dateFromKey(sortedDays[i - 1]);
      final currentDate = _dateFromKey(sortedDays[i]);

      final difference = currentDate.difference(previous).inDays;

      if (difference == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (difference > 1) {
        current = 1;
      }
    }

    return longest;
  }

  DateTime _dateFromKey(int key) {
    final year = key ~/ 10000;
    final month = (key % 10000) ~/ 100;
    final day = key % 100;

    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activeDays = sessions
        .map((session) => _dateKey(session.completedAt))
        .toSet();

    final sortedDays = activeDays.toList()..sort();

    final currentStreak = _getCurrentStreak(activeDays);
    final longestStreak = _getLongestStreak(sortedDays);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Monday is the first day of the week.
    final weekStart = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final weeklySessions = sessions.where((session) {
      final sessionDate = session.completedAt.toLocal();

      return !sessionDate.isBefore(weekStart) &&
          !sessionDate.isAfter(today.add(const Duration(days: 1)));
    }).length;

    final progress = (weeklySessions / weeklyGoal).clamp(0.0, 1.0);
    final goalCompleted = weeklySessions >= weeklyGoal;

    String motivationalMessage;

    if (goalCompleted) {
      motivationalMessage =
          'Amazing! You have achieved your weekly speaking goal.';
    } else if (currentStreak >= 3) {
      motivationalMessage =
          'Great consistency! Keep your speaking streak alive.';
    } else if (weeklySessions > 0) {
      motivationalMessage =
          'Good start! Keep practising to reach your weekly goal.';
    } else {
      motivationalMessage =
          'Start your week with a speaking session and build your streak!';
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
                  Icons.local_fire_department_rounded,
                  color: Colors.orange.shade700,
                  size: 25,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Speaking Streak',
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
                  child: _StreakMetric(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    value: '$currentStreak days',
                    label: 'Current streak',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StreakMetric(
                    icon: Icons.emoji_events_outlined,
                    iconColor: Colors.amber.shade800,
                    value: '$longestStreak days',
                    label: 'Longest streak',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly speaking goal',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$weeklySessions / $weeklyGoal sessions',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  goalCompleted
                      ? Colors.green
                      : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              motivationalMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakMetric extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StreakMetric({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
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
          Icon(icon, color: iconColor, size: 22),
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

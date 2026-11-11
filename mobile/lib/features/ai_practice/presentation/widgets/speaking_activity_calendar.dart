
import 'package:flutter/material.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingActivityCalendar extends StatefulWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingActivityCalendar({
    super.key,
    required this.sessions,
  });

  @override
  State<SpeakingActivityCalendar> createState() =>
      _SpeakingActivityCalendarState();
}

class _SpeakingActivityCalendarState
    extends State<SpeakingActivityCalendar> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  Map<int, int> _getMonthlyActivity() {
    final activity = <int, int>{};

    for (final session in widget.sessions) {
      final date = session.completedAt.toLocal();

      if (date.year == _selectedMonth.year &&
          date.month == _selectedMonth.month) {
        activity.update(
          date.day,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return activity;
  }

  void _changeMonth(int difference) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + difference,
      );
    });
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = _getMonthlyActivity();

    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    final firstWeekday = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    ).weekday;

    final totalSessions = activity.values.fold<int>(
      0,
      (total, count) => total + count,
    );

    final today = DateTime.now();

    final isCurrentMonth = _selectedMonth.year == today.year &&
        _selectedMonth.month == today.month;

    final cells = <Widget>[];

    for (int i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final sessionCount = activity[day] ?? 0;

      final isToday = isCurrentMonth && day == today.day;

      cells.add(
        _CalendarDay(
          day: day,
          sessionCount: sessionCount,
          isToday: isToday,
        ),
      );
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
                  Icons.calendar_month_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Speaking Activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous month',
                ),
                Text(
                  _monthName(_selectedMonth),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: isCurrentMonth
                      ? null
                      : () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next month',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 6,
              children: cells,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.record_voice_over_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sessions this month',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '$totalSessions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'Practised',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 18),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'No practice',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final int sessionCount;
  final bool isToday;

  const _CalendarDay({
    required this.day,
    required this.sessionCount,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = sessionCount > 0;

    return Tooltip(
      message: isActive
          ? '$sessionCount speaking session(s)'
          : 'No speaking practice',
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: isToday
              ? Border.all(
                  color: theme.colorScheme.tertiary,
                  width: 2,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isActive
                    ? Colors.white
                    : theme.colorScheme.onSurface,
                fontWeight: isToday || isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            if (sessionCount > 1)
              Text(
                '$sessionCount',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

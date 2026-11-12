
import 'package:mobile/features/ai_practice/domain/models/speaking_challenge.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingChallengeService {
  const SpeakingChallengeService();

  List<SpeakingChallenge> calculateChallenges(
    List<SpeakingSessionResult> sessions,
  ) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    // Monday is the first day of the week.
    final weekStart = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final todaySessions = sessions.where((session) {
      final date = session.completedAt.toLocal();

      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();

    final weeklySessions = sessions.where((session) {
      final date = session.completedAt.toLocal();

      return !date.isBefore(weekStart) &&
          !date.isAfter(today.add(const Duration(days: 1)));
    }).toList();

    final todayWords = todaySessions.fold<int>(
      0,
      (total, session) =>
          total + session.metrics.spokenWordCount,
    );

    final weeklyWords = weeklySessions.fold<int>(
      0,
      (total, session) =>
          total + session.metrics.spokenWordCount,
    );

    final weeklyActiveDays = weeklySessions
        .map((session) {
          final date = session.completedAt.toLocal();

          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .length;

    return [
      _createChallenge(
        id: 'daily_speaker',
        title: 'Daily Speaker',
        description: 'Complete one speaking session today.',
        target: 1,
        current: todaySessions.length,
        unit: 'sessions',
      ),
      _createChallenge(
        id: 'word_builder',
        title: 'Word Builder',
        description: 'Speak 100 words today.',
        target: 100,
        current: todayWords,
        unit: 'words',
      ),
      _createChallenge(
        id: 'weekly_champion',
        title: 'Weekly Champion',
        description: 'Complete five speaking sessions this week.',
        target: 5,
        current: weeklySessions.length,
        unit: 'sessions',
      ),
      _createChallenge(
        id: 'word_explorer',
        title: 'Word Explorer',
        description: 'Speak 500 words this week.',
        target: 500,
        current: weeklyWords,
        unit: 'words',
      ),
      _createChallenge(
        id: 'consistency_master',
        title: 'Consistency Master',
        description: 'Practise on three different days this week.',
        target: 3,
        current: weeklyActiveDays,
        unit: 'days',
      ),
    ];
  }

  SpeakingChallenge _createChallenge({
    required String id,
    required String title,
    required String description,
    required int target,
    required int current,
    required String unit,
  }) {
    return SpeakingChallenge(
      id: id,
      title: title,
      description: description,
      target: target,
      currentProgress: current,
      unit: unit,
    );
  }
}

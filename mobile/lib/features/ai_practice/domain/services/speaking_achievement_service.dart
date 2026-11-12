
import 'package:flutter/material.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_achievement.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingAchievementService {
  const SpeakingAchievementService();

  List<SpeakingAchievement> calculateAchievements(
    List<SpeakingSessionResult> sessions,
  ) {
    final totalSessions = sessions.length;

    final totalWords = sessions.fold<int>(
      0,
      (total, session) => total + session.metrics.spokenWordCount,
    );

    final activeDays = sessions
        .map((session) {
          final date = session.completedAt.toLocal();

          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .toList()
      ..sort();

    final longestStreak = _calculateLongestStreak(activeDays);

    return [
      _createAchievement(
        id: 'first_words',
        title: 'First Words',
        description: 'Complete your first speaking session.',
        icon: Icons.record_voice_over_rounded,
        target: 1,
        current: totalSessions,
      ),
      _createAchievement(
        id: 'getting_started',
        title: 'Getting Started',
        description: 'Complete 5 speaking sessions.',
        icon: Icons.rocket_launch_rounded,
        target: 5,
        current: totalSessions,
      ),
      _createAchievement(
        id: 'dedicated_speaker',
        title: 'Dedicated Speaker',
        description: 'Complete 10 speaking sessions.',
        icon: Icons.mic_rounded,
        target: 10,
        current: totalSessions,
      ),
      _createAchievement(
        id: 'week_warrior',
        title: 'Week Warrior',
        description: 'Practise speaking for 7 consecutive days.',
        icon: Icons.local_fire_department_rounded,
        target: 7,
        current: longestStreak,
      ),
      _createAchievement(
        id: 'word_explorer',
        title: 'Word Explorer',
        description: 'Speak a total of 500 words.',
        icon: Icons.menu_book_rounded,
        target: 500,
        current: totalWords,
      ),
      _createAchievement(
        id: 'practice_champion',
        title: 'Practice Champion',
        description: 'Complete 50 speaking sessions.',
        icon: Icons.emoji_events_rounded,
        target: 50,
        current: totalSessions,
      ),
    ];
  }

  SpeakingAchievement _createAchievement({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required int target,
    required int current,
  }) {
    return SpeakingAchievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      target: target,
      currentProgress: current,
    );
  }

  int _calculateLongestStreak(List<DateTime> activeDays) {
    if (activeDays.isEmpty) return 0;

    int longest = 1;
    int current = 1;

    for (int i = 1; i < activeDays.length; i++) {
      final difference = activeDays[i]
          .difference(activeDays[i - 1])
          .inDays;

      if (difference == 1) {
        current++;

        if (current > longest) {
          longest = current;
        }
      } else if (difference > 1) {
        current = 1;
      }
    }

    return longest;
  }
}

import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/data/repositories/ai_practice_repository_provider.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/repositories/speaking_session_repository.dart';
import 'package:mobile/features/ai_practice/presentation/screens/speaking_session_details_screen.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/speaking_progress_chart.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/speaking_progress_insights.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/speaking_streak_card.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/speaking_activity_calendar.dart';
import 'package:mobile/features/ai_practice/presentation/widgets/speaking_achievements_card.dart';

class SpeakingHistoryScreen extends StatefulWidget {
  const SpeakingHistoryScreen({super.key});

  @override
  State<SpeakingHistoryScreen> createState() => _SpeakingHistoryScreenState();
}

class _SpeakingHistoryScreenState extends State<SpeakingHistoryScreen> {
  final SpeakingSessionRepository _repository =
      AiPracticeRepositoryProvider.speakingSessionRepository;

  late Future<List<SpeakingSessionResult>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = _repository.getSessions();
  }

  Future<void> _refreshSessions() async {
    setState(() {
      _sessionsFuture = _repository.getSessions();
    });

    await _sessionsFuture;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes == 0) {
      return '${remainingSeconds}s';
    }

    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Speaking History',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: FutureBuilder<List<SpeakingSessionResult>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshSessions,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildHeader(sessions.length),
                const SizedBox(height: 24),

                _buildProgressOverview(sessions),
                const SizedBox(height: 24),

                SpeakingProgressChart(sessions: sessions),
                const SizedBox(height: 24),

                SpeakingProgressInsights(sessions: sessions),
                const SizedBox(height: 24),

                SpeakingStreakCard(sessions: sessions),
                const SizedBox(height: 24),

                SpeakingActivityCalendar(sessions: sessions),
                const SizedBox(height: 24),

                SpeakingAchievementsCard(sessions: sessions),
                const SizedBox(height: 24),

                ...sessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildSessionCard(session),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int sessionCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
          const SizedBox(height: 12),
          const Text(
            'Your speaking journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$sessionCount completed ${sessionCount == 1 ? 'session' : 'sessions'}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(List<SpeakingSessionResult> sessions) {
    final totalWords = sessions.fold<int>(
      0,
      (total, session) => total + session.metrics.spokenWordCount,
    );

    final totalDuration = sessions.fold<int>(
      0,
      (total, session) => total + session.metrics.durationSeconds,
    );

    final totalScore = sessions.fold<double>(
      0,
      (total, session) => total + session.metrics.practiceScore,
    );

    final averageScore = totalScore / sessions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Overall Progress',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.65,
          children: [
            _buildProgressStat(
              Icons.forum_rounded,
              'Sessions',
              '${sessions.length}',
              const Color(0xFF2563EB),
            ),
            _buildProgressStat(
              Icons.timer_rounded,
              'Practice Time',
              _formatTotalDuration(totalDuration),
              const Color(0xFF7C3AED),
            ),
            _buildProgressStat(
              Icons.record_voice_over_rounded,
              'Words Spoken',
              totalWords.toString(),
              const Color(0xFF0891B2),
            ),
            _buildProgressStat(
              Icons.trending_up_rounded,
              'Average Score',
              '${averageScore.toStringAsFixed(0)}/100',
              const Color(0xFF16A34A),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStat(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTotalDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    return '${minutes}m';
  }

  Widget _buildSessionCard(SpeakingSessionResult session) {
    final score = session.metrics.practiceScore;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SpeakingSessionDetailsScreen(session: session),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.scenario,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(0)}/100',
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                '${session.difficulty} • ${_formatDate(session.completedAt)}',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  _buildMetric(
                    Icons.timer_outlined,
                    _formatDuration(session.metrics.durationSeconds),
                    'Duration',
                  ),
                  const SizedBox(width: 20),
                  _buildMetric(
                    Icons.record_voice_over_rounded,
                    '${session.metrics.spokenWordCount}',
                    'Words spoken',
                  ),
                  const SizedBox(width: 20),
                  _buildMetric(
                    Icons.chat_bubble_outline_rounded,
                    '${session.metrics.spokenTurnCount}',
                    'Turns',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 19),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history_rounded,
              size: 64,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 18),
            const Text(
              'No speaking sessions yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete your first AI speaking session '
              'and your progress will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load speaking history',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sessionsFuture = _repository.getSessions();
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

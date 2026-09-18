import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/repositories/speaking_session_repository.dart';

class InMemorySpeakingSessionRepository
    implements SpeakingSessionRepository {
  final List<SpeakingSessionResult> _sessions = [];

  @override
  Future<void> saveSession(SpeakingSessionResult result) async {
    _sessions.add(result);
  }

  @override
  Future<List<SpeakingSessionResult>> getSessions() async {
    final sortedSessions = List<SpeakingSessionResult>.from(_sessions)
      ..sort(
        (a, b) => b.completedAt.compareTo(a.completedAt),
      );

    return List.unmodifiable(sortedSessions);
  }

  @override
  Future<void> clearSessions() async {
    _sessions.clear();
  }

  List<SpeakingSessionResult> get sessions =>
      List.unmodifiable(_sessions);
}
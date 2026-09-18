import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

abstract class SpeakingSessionRepository {
  Future<void> saveSession(SpeakingSessionResult result);

  Future<List<SpeakingSessionResult>> getSessions();

  Future<void> clearSessions();
}
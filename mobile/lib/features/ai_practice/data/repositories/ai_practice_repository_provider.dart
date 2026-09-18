import 'in_memory_speaking_session_repository.dart';

class AiPracticeRepositoryProvider {
  AiPracticeRepositoryProvider._();

  static final InMemorySpeakingSessionRepository
      speakingSessionRepository =
      InMemorySpeakingSessionRepository();
}
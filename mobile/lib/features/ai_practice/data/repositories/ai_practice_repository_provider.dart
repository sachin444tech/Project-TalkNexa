import 'package:mobile/features/ai_practice/data/repositories/firestore_speaking_session_repository.dart';
import 'package:mobile/features/ai_practice/domain/repositories/speaking_session_repository.dart';

class AiPracticeRepositoryProvider {
  AiPracticeRepositoryProvider._();

  static final SpeakingSessionRepository speakingSessionRepository =
      FirestoreSpeakingSessionRepository();
}
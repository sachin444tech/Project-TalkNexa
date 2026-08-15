import 'package:mobile/features/ai_practice/data/services/ai_api_service.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_conversation_context.dart';

class AiConversationService {
  final AiApiService _apiService =
      AiApiService();

  Future<String> generateResponse({
    required String userMessage,
    required AiConversationContext context,
  }) async {
    return await _apiService.generateResponse(
      message: userMessage,
      scenario: context.scenario,
      difficulty: context.difficulty,
      userLevel: context.userLevel,
    );
  }
}
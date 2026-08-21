import 'package:mobile/features/ai_practice/data/services/ai_api_service.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_conversation_context.dart';
import 'package:mobile/features/ai_practice/domain/models/ai_response.dart';

class AiConversationService {
  final AiApiService _apiService =
      AiApiService();

  Future<AiResponse> generateResponse({
    required String userMessage,
    required AiConversationContext context,
    required List<Map<String, String>> conversationHistory,
  }) async {
    return await _apiService.generateResponse(
      message: userMessage,
      scenario: context.scenario,
      difficulty: context.difficulty,
      userLevel: context.userLevel,
      conversationHistory: conversationHistory,
    );
  }
}
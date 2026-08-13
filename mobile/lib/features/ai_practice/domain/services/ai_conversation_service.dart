import 'package:mobile/features/ai_practice/domain/models/ai_conversation_context.dart';


class AiConversationService {
  Future<String> generateResponse({
    required String userMessage,
    required AiConversationContext context,
  }) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return _generateFallbackResponse(
      userMessage: userMessage,
      context: context,
    );
  }

  String _generateFallbackResponse({
    required String userMessage,
    required AiConversationContext context,
  }) {
    final message =
        userMessage.toLowerCase();

    if (message.contains('hello') ||
        message.contains('hi')) {
      return 'Hello! It is great to talk with you. '
          'Tell me something interesting about yourself.';
    }

    if (message.contains('study') ||
        message.contains('college') ||
        message.contains('university')) {
      return 'That sounds interesting. '
          'What do you enjoy most about your studies?';
    }

    if (message.contains('job') ||
        message.contains('work')) {
      return 'That is interesting. '
          'What kind of work would you like to do in the future?';
    }

    return 'That is interesting! '
        'Could you tell me a little more about that?';
  }
}
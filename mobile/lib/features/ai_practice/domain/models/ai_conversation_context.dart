import 'package:mobile/features/ai_practice/domain/models/chat_message.dart';

class AiConversationContext {
  final String scenario;
  final String difficulty;
  final String userLevel;
  final List<ChatMessage> messages;

  const AiConversationContext({
    required this.scenario,
    required this.difficulty,
    required this.userLevel,
    this.messages = const [],
  });
}

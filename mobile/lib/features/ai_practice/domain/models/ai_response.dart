import 'package:mobile/features/ai_practice/domain/models/ai_feedback.dart';

class AiResponse {
  final String response;
  final AiFeedback feedback;

  const AiResponse({
    required this.response,
    required this.feedback,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      response: json['response'] as String,
      feedback: AiFeedback.fromJson(
        json['feedback'] as Map<String, dynamic>,
      ),
    );
  }
}
import 'ai_feedback.dart';

class AiResponse {
  final String response;
  final AiFeedback feedback;
  final String scenario;
  final String difficulty;
  final String userLevel;

  const AiResponse({
    required this.response,
    required this.feedback,
    required this.scenario,
    required this.difficulty,
    required this.userLevel,
  });

  factory AiResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiResponse(
      response:
          json['response'] as String? ?? '',
      feedback: AiFeedback.fromJson(
        json['feedback'] as Map<String, dynamic>? ??
            {},
      ),
      scenario:
          json['scenario'] as String? ?? '',
      difficulty:
          json['difficulty'] as String? ?? '',
      userLevel:
          json['userLevel'] as String? ?? '',
    );
  }
}
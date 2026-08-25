class AiResponse {
  final String response;
  final AiFeedback feedback;

  const AiResponse({required this.response, required this.feedback});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      response: json['response'] as String,
      feedback: AiFeedback.fromJson(json['feedback'] as Map<String, dynamic>),
    );
  }
}

class AiFeedback {
  final bool hasCorrection;
  final String original;
  final String corrected;
  final String explanation;

  const AiFeedback({
    required this.hasCorrection,
    required this.original,
    required this.corrected,
    required this.explanation,
  });

  factory AiFeedback.fromJson(Map<String, dynamic> json) {
    return AiFeedback(
      hasCorrection: json['hasCorrection'] as bool? ?? false,
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

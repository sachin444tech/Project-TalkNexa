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
      hasCorrection: json['hasCorrection'] == true,
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

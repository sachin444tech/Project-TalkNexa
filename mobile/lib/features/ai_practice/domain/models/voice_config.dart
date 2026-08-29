class VoiceConfig {
  final String language;
  final double speechRate;
  final double pitch;
  final double volume;

  const VoiceConfig({
    required this.language,
    required this.speechRate,
    required this.pitch,
    required this.volume,
  });

  static const defaultConfig = VoiceConfig(
    language: 'en-US',
    speechRate: 0.48,
    pitch: 1.0,
    volume: 1.0,
  );
}

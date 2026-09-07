class VoiceConfig {
  final String language;
  final double speechRate;
  final double pitch;
  final double volume;
  final String? voice;

  const VoiceConfig({
    required this.language,
    required this.speechRate,
    required this.pitch,
    required this.volume,
    this.voice,
  });

  static const defaultConfig = VoiceConfig(
  language: 'en-US',
  speechRate: 0.48,
  pitch: 1.0,
  volume: 1.0,
  voice: 'en-us-x-tpf-local',
  );
}

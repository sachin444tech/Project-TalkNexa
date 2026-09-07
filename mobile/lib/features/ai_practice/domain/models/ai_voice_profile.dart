import 'package:mobile/features/ai_practice/domain/models/voice_config.dart';

class AiVoiceProfile {
  final String name;
  final VoiceConfig config;

  const AiVoiceProfile({required this.name, required this.config});

  static const defaultProfile = AiVoiceProfile(
    name: 'TalkNexa Default',
    config: VoiceConfig.defaultConfig,
  );
}

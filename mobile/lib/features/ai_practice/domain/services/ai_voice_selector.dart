import 'package:mobile/features/ai_practice/domain/models/ai_voice_profile.dart';
import 'package:mobile/features/ai_practice/domain/models/voice_config.dart';

class AiVoiceSelector {
  const AiVoiceSelector();

  AiVoiceProfile select({
    required String scenario,
    required String difficulty,
  }) {
    final normalizedScenario = scenario.trim().toLowerCase();
    final normalizedDifficulty = difficulty.trim().toLowerCase();

    if (normalizedScenario == 'job interview') {
      return AiVoiceProfile(
        name: 'Professional Interviewer',
        config: VoiceConfig.defaultConfig,
      );
    }

    if (normalizedScenario == 'travel') {
      return AiVoiceProfile(
        name: 'Friendly Travel Partner',
        config: VoiceConfig(
          language: 'en-US',
          speechRate: 0.50,
          pitch: 1.05,
        volume: 1.0,
        voice: 'en-us-x-tpf-local',
        ),
      );
    }

    if (normalizedScenario == 'college') {
      return AiVoiceProfile(
        name: 'Friendly College Partner',
        config: VoiceConfig(
          language: 'en-US',
          speechRate: 0.50,
          pitch: 1.02,
          volume: 1.0,
          voice: 'en-us-x-tpf-local',
          ),
      );
    }

    if (normalizedScenario == 'daily life') {
      return AiVoiceProfile(
        name: 'Casual Conversation Partner',
        config: VoiceConfig(
          language: 'en-US',
          speechRate: 0.52,
          pitch: 1.04,
          volume: 1.0,
          voice: 'en-us-x-tpf-local',
          ),
      );
    }

    if (normalizedScenario == 'role play') {
      return AiVoiceProfile(
        name: 'Role Play Partner',
        config: VoiceConfig(
          language: 'en-US',
          speechRate: normalizedDifficulty == 'hard' ? 0.54 : 0.50,
          pitch: 1.0,
          volume: 1.0,
          voice: 'en-us-x-tpf-local',
          ),
      );
    }

    return AiVoiceProfile.defaultProfile;
  }
}

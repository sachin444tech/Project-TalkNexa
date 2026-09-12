import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile/features/ai_practice/domain/models/voice_config.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  final VoiceConfig _config;

  bool _initialized = false;

  bool _disposed = false;

  Completer<void>? _speechCompleter;

  TextToSpeechService({this._config = VoiceConfig.defaultConfig});

  Future<void> initialize() async {
    if (_disposed) return;

    if (_initialized) return;

    await _flutterTts.setLanguage(_config.language);

    if (_config.voice != null) {
      final voiceSelected = await setVoice(_config.voice!);

      if (!voiceSelected) {
        await _flutterTts.setLanguage('en-US');
      }
    }

    await _flutterTts.setSpeechRate(_config.speechRate);
    await _flutterTts.setPitch(_config.pitch);
    await _flutterTts.setVolume(_config.volume);
    await _flutterTts.setLanguage(_config.language);

    _flutterTts.setCompletionHandler(() {
      final completer = _speechCompleter;

      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    });

    _flutterTts.setErrorHandler((message) {
      final completer = _speechCompleter;

      if (completer != null && !completer.isCompleted) {
        completer.completeError(Exception('Text-to-speech error: $message'));
      }
    });

    _initialized = true;
  }

  Future<List<Map<String, dynamic>>> getAvailableVoices() async {
    if (_disposed) return [];

    await initialize();

    final voices = await _flutterTts.getVoices;

    if (voices is! List) {
      return [];
    }

    return voices
        .whereType<Map>()
        .map((voice) => Map<String, dynamic>.from(voice))
        .toList();
  }

  Future<bool> setVoice(String voiceName) async {
    if (_disposed) return false;

    try {
      final voices = await _flutterTts.getVoices;

      if (voices is! List) {
        return false;
      }

      final availableVoices = voices
          .whereType<Map>()
          .map((voice) => Map<String, dynamic>.from(voice))
          .toList();

      final matchingVoice = availableVoices
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (voice) =>
                voice?['name']?.toString().toLowerCase() ==
                    voiceName.toLowerCase() &&
                voice?['locale']?.toString().toLowerCase() ==
                    _config.language.toLowerCase(),
            orElse: () => null,
          );

      if (matchingVoice == null) {
        return false;
      }

      await _flutterTts.setVoice({
        'name': matchingVoice['name'],
        'locale': matchingVoice['locale'],
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text) async {
    if (_disposed) return;

    final trimmedText = text.trim();

    if (trimmedText.isEmpty) return;

    await initialize();

    await stop();

    final completer = Completer<void>();
    _speechCompleter = completer;

    try {
      await _flutterTts.speak(trimmedText);

      await completer.future;
    } finally {
      if (identical(_speechCompleter, completer)) {
        _speechCompleter = null;
      }
    }
  }

  Future<void> stop() async {
  if (_disposed) {
    _speechCompleter = null;
    return;
  }

  await _flutterTts.stop();

  if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
    _speechCompleter!.complete();
  }

  _speechCompleter = null;
}

  Future<void> interrupt() async {
    await stop();
  }

  Future<void> pause() async {
    if (_disposed) return;

    await _flutterTts.pause();
  }

  Future<void> dispose() async {
  if (_disposed) return;

  await _flutterTts.stop();

  if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
    _speechCompleter!.complete();
  }

  _speechCompleter = null;
  _disposed = true;
  }
}

import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile/features/ai_practice/domain/models/voice_config.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  final VoiceConfig _config;

  bool _initialized = false;

  Completer<void>? _speechCompleter;

  TextToSpeechService({this._config = VoiceConfig.defaultConfig});

  Future<void> initialize() async {
    if (_initialized) return;

    await _flutterTts.setLanguage(_config.language);
    await _flutterTts.setSpeechRate(_config.speechRate);
    await _flutterTts.setPitch(_config.pitch);
    await _flutterTts.setVolume(_config.volume);

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

  Future<void> speak(String text) async {
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
    await _flutterTts.pause();
  }

  Future<void> dispose() async {
    await stop();
  }
}

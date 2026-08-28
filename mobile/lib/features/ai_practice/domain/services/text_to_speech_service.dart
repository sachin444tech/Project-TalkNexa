import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  bool _initialized = false;

  Completer<void>? _speechCompleter;

  Future<void> initialize() async {
    if (_initialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.48);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

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

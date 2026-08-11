import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isInitialized = false;

  bool get isListening => _speechToText.isListening;

  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    _isInitialized = await _speechToText.initialize();

    return _isInitialized;
  }

  Future<bool> startListening({
    required void Function(String text, bool isFinal)
        onResult,
  }) async {
    final available = await initialize();

    if (!available) {
      return false;
    }

    await _speechToText.listen(
      onResult: (result) {
        onResult(
          result.recognizedWords,
          result.finalResult,
        );
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );

    return true;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  Future<void> dispose() async {
    await _speechToText.cancel();
  }
}
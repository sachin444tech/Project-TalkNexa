import 'package:record/record.dart';

class MicrophoneService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final hasAccess = await _recorder.hasPermission();

    if (!hasAccess) {
      throw Exception(
        'Microphone permission was not granted.',
      );
    }

    await _recorder.start(
      const RecordConfig(),
      path: '',
    );
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/audio.dart';

class AudioPicker {
  static Future<AudioEntity> pick() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      PlatformFile platformFile = result.files.single;
      File file = File(platformFile.path);
      Uint8List audioBytes = file.readAsBytesSync();

      final audioEntity = AudioEntity(
        title: platformFile.name,
        audioData: audioBytes,
      );

      return audioEntity;
    }

    return null;
  }
}

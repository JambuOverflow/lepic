import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/audio.dart';

class AudioPicker {
  static Future<FilePickerResult> pick() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
  }

  static AudioEntity pickerResultToAudioEntity(FilePickerResult result) {
    PlatformFile platformFile = result.files.single;
    File file = File(platformFile.path);
    Uint8List audioBytes = file.readAsBytesSync();

    final audioEntity = AudioEntity(
      title: platformFile.name,
      data: audioBytes,
    );

    return audioEntity;
  }
}

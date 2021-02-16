import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future uploadAudio() async {
  PlatformFile file =
      (await FilePicker.platform.pickFiles(type: FileType.audio))?.files[0];
  Uint8List audioBytes = File(file.path).readAsBytesSync();
  return [audioBytes, file.name];
}

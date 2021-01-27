import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';

void addOrUpdateAudio(bloc) async {
  PlatformFile file =
      (await FilePicker.platform.pickFiles(type: FileType.audio))?.files[0];
  Uint8List audioBytes = File(file.path).readAsBytesSync();

  bloc.isAudioAttached
      ? bloc.add(UpdateAudioEvent(
          oldAudio: bloc.audio, audioData: audioBytes, title: file.name))
      : bloc.add(CreateAudioEvent(audioData: audioBytes, title: file.name));
}

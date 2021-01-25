import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/services.dart';

void _playAudio(_audioBytes) async {
  Audio.loadFromByteData(ByteData.view(_audioBytes.buffer))
    ..play()
    ..dispose();
}

// TODO: Implement another audio controllers (pause, forward, etc.), it may need Bloc

import 'package:audioplayers/audioplayers.dart';

void playAudio(audioBytes) async {
  AudioPlayer audioPlayer = AudioPlayer();
  int _ = await audioPlayer.playBytes(audioBytes);
}

import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'audio_bloc.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final AudioBloc audioBloc;

  Audio _audio;
  double durationInSeconds;
  double currentPositon;

  ByteData get _audioByteData => audioBloc.audio.byteData;

  PlayerCubit(this.audioBloc) : super(PlayerInitial()) {
    currentPositon = 0;
    loadAudio();
    audioBloc.listen((state) {
      if (state is AudioLoaded) loadAudio();
    });
  }

  @override
  Future<void> close() {
    print('closing!');
    _audio
      ..pause()
      ..dispose();
    _audio = null;
    emit(PlayerInitial());
    return super.close();
  }

  void loadAudio() {
    _audio?.dispose();

    _audio = Audio.loadFromByteData(
      _audioByteData,
      onDuration: (duration) => this.durationInSeconds = duration,
      onPosition: (position) {
        this.currentPositon = position;
        emit(PlayerPlaying(position: position));
      },
    );
  }

  void play() {
    _audio..play();
    emit(PlayerPlaying(position: currentPositon));
  }

  void stop() {
    _audio
      ..pause()
      ..seek(0);
    currentPositon = 0;

    emit(PlayerInitial());
  }

  void pause() {
    _audio..pause();
    emit(PlayerPaused());
  }

  void resume() {
    _audio..resume();
    emit(PlayerPlaying(position: currentPositon));
  }

  void forward({int seconds}) {
    backwards(seconds: -seconds);
  }

  void backwards({int seconds}) {
    if (state is PlayerInitial) return;

    final newPosition =
        (currentPositon + (-seconds)).clamp(0, durationInSeconds);

    _audio..seek(newPosition);
    emit(PlayerPlaying(position: newPosition));
  }

  String formattedDuration() {
    if (durationInSeconds == null) return '--:--';

    final duration = Duration(seconds: durationInSeconds.toInt());

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    var minutes = twoDigits(duration.inMinutes.remainder(60));
    var seconds = twoDigits((duration.inSeconds.remainder(60)));

    return '$minutes:$seconds';
  }

  String formattedPosition() {
    if (durationInSeconds == null) return '00:00';

    final position = Duration(seconds: currentPositon.toInt());

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    var minutes = twoDigits(position.inMinutes.remainder(60));
    var seconds = twoDigits((position.inSeconds.remainder(60)));

    return '$minutes:$seconds';
  }

  double progressPercentage() {
    if (state is PlayerPlaying || state is PlayerPaused)
      return currentPositon / durationInSeconds;
    else
      return 0;
  }
}

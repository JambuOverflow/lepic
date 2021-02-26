import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils/audio_text_utils.dart';
import 'audio_bloc.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final AudioBloc audioBloc;

  Audio _audio;
  double durationInSeconds;
  double currentPositon = 0;

  ByteData get _audioByteData => audioBloc.audio.byteData;

  PlayerCubit(this.audioBloc) : super(PlayerInitial()) {
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
      onComplete: () => stop(),
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

    final double offset = 0.01;
    final double newPosition =
        (currentPositon + (-seconds)).clamp(offset, durationInSeconds - offset);

    _audio..seek(newPosition);
    emit(PlayerPlaying(position: newPosition));
  }

  String formattedDuration() =>
      AudioTextUtils.formattedDuration(durationInSeconds: durationInSeconds);

  String formattedPosition() =>
      AudioTextUtils.formattedPosition(currentPosition: currentPositon);

  double progressPercentage() {
    if (state is PlayerPlaying || state is PlayerPaused)
      return currentPositon / durationInSeconds;
    else
      return 0;
  }
}

part of 'audio_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class CreateAudioEvent extends AudioEvent {
  final String title;
  final Uint8List audioData;

  CreateAudioEvent({
    @required this.title,
    @required this.audioData,
  });
}

class UpdateAudioEvent extends AudioEvent {
  final String title;
  final Uint8List audioData;

  final AudioEntity oldAudio;

  UpdateAudioEvent({
    this.title,
    this.audioData,
    @required this.oldAudio,
  });
}

class DeleteAudioEvent extends AudioEvent {}

class LoadAudioEvent extends AudioEvent {}

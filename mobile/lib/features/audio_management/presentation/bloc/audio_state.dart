part of 'audio_bloc.dart';

abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [AudioState];
}

class AudioLoadInProgress extends AudioState {}

class AudioLoaded extends AudioState {
  final AudioEntity audio;

  AudioLoaded({@required this.audio});

  @override
  List<Object> get props => [audio];
}

class AudioDurationLoaded extends AudioState {
  final Duration duration;

  AudioDurationLoaded(this.duration);

  @override
  List<Object> get props => [duration];
}

class Error extends AudioState {
  final String message;

  Error({@required this.message});
}

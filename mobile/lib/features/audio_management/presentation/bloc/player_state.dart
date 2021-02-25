part of 'player_cubit.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerPlaying extends PlayerState {
  final double position;

  PlayerPlaying({@required this.position});

  @override
  List<Object> get props => [position];
}

class PlayerPaused extends PlayerState {}

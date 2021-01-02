part of 'text_bloc.dart';

abstract class TextState extends Equatable {
  const TextState();
  @override
  List<Object> get props => [TextState];
}

class TextsLoadInProgress extends TextState {}

class TextsLoaded extends TextState {}

class Error extends TextState {
  final String message;

  Error({@required this.message});
}

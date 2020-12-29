part of 'text_bloc.dart';

abstract class TextState extends Equatable {
  const TextState();
  @override
  List<Object> get props => [TextState];
}

class DeletingText extends TextState {}

class TextDeleted extends TextState {}

class CreatingText extends TextState {}

class TextCreated extends TextState {
  final MyText text;

  TextCreated({@required this.text});

  @override
  List<Object> get props => [text];
}

class UpdatingText extends TextState {}

class TextUpdated extends TextState {
  final MyText text;

  TextUpdated({@required this.text});
  @override
  List<Object> get props => [text];
}

class GettingTexts extends TextState {}

class TextsGot extends TextState {
  final List<MyText> texts;

  TextsGot({@required this.texts});

  @override
  List<Object> get props => [texts];
}

class Error extends TextState {
  final String message;

  Error({@required this.message});
}

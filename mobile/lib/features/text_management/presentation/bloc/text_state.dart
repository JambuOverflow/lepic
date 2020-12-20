part of 'text_bloc.dart';

@immutable
abstract class TextState extends Equatable {
  const TextState();
  @override
  List<Object> get props => [TextState];
}


class TextInitial extends TextState {}

class TextNotLoaded extends TextState {}

class DeletingText extends TextState {}

class TextDeleted extends TextState {}

class CreatingText extends TextState {}

class TextCreated extends TextState {
  final MyText text;

  TextCreated({@required this.text});
}

class UpdatingText extends TextState {}

class TextUpdated extends TextState {
  final MyText text;

  TextUpdated({@required this.text});
}

class GettingTextList extends TextState {}

class GotTextList extends TextState {
  final List<MyText> texts;
  GotTextList({@required this.texts});
}

class Error extends TextState {
  final String message;

  Error({@required this.message});
}

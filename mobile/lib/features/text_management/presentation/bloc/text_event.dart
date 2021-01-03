part of 'text_bloc.dart';

@immutable
abstract class TextEvent extends Equatable {
  const TextEvent();
  @override
  List<Object> get props => [];
}

class CreateTextEvent extends TextEvent {
  final String title;
  final String body;

  CreateTextEvent({
    @required this.title,
    @required this.body,
  });
}

class UpdateTextEvent extends TextEvent {
  final String title;
  final String body;

  final MyText oldText;

  UpdateTextEvent({
    this.title,
    this.body,
    @required this.oldText,
  });
}

class DeleteTextEvent extends TextEvent {
  final MyText text;

  DeleteTextEvent({@required this.text});
}

class GetTextsEvent extends TextEvent {}

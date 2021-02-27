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
  final DateTime creationDate;

  CreateTextEvent({
    @required this.title,
    @required this.body,
    @required this.creationDate,
  });
}

class UpdateTextEvent extends TextEvent {
  final String title;
  final String body;
  final DateTime creationDate;

  final MyText oldText;

  UpdateTextEvent({
    this.title,
    this.body,
    @required this.oldText,
    this.creationDate,
  });
}

class DeleteTextEvent extends TextEvent {
  final MyText text;

  DeleteTextEvent({@required this.text});
}

class GetTextsEvent extends TextEvent {}

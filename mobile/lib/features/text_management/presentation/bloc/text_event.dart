part of 'text_bloc.dart';

abstract class TextEvent extends Equatable {
  const TextEvent();

  @override
  List<Object> get props => [];
}

class CreateTextEvent extends TextEvent {
  final Classroom classroom;
  final String title;
  final String body;

  CreateTextEvent({
    @required this.classroom,
    @required this.title,
    @required this.body,
  });
}

class UpdateTextEvent extends TextEvent {
  final MyText oldText;
  final Classroom classroom;
  final String title;
  final String body;

  UpdateTextEvent({
    @required this.oldText,
    @required this.classroom,
    @required this.title,
    @required this.body,
  });
}

class DeleteTextEvent extends TextEvent {
  final MyText text;

  DeleteTextEvent({@required this.text});
}

class GetTextsEvent extends TextEvent {}

part of 'text_bloc.dart';

@immutable
abstract class TextEvent extends Equatable {
  const TextEvent();
  @override
  List<Object> get props => [];
}

abstract class _TextManagementEvent extends TextEvent {
  final String title;
  final String body;

  _TextManagementEvent(
    this.title,
    this.body,
  );
}

class CreateTextEvent extends _TextManagementEvent {
  final Classroom classroom;

  CreateTextEvent({
    String title,
    @required String body,
    @required this.classroom,
  }) : super(title, body);
}

class UpdateTextEvent extends _TextManagementEvent {
  final MyText oldText;

  UpdateTextEvent({
    String title,
    String body,
    @required this.oldText,
  }) : super(title, body);
}

class DeleteTextEvent extends TextEvent {
  final int localId;

  DeleteTextEvent({@required this.localId});
}

class GetTextsEvent extends TextEvent {
  final Classroom classroom;

  GetTextsEvent({@required this.classroom});
}

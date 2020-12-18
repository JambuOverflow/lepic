part of 'text_bloc.dart';

@immutable
abstract class TextEvent extends Equatable {
  const TextEvent();

  @override
  List<Object> get props => [];
}

class _TextManagementEvent extends TextEvent {
  final String title;
  final String body;
  final int localId;
  final int classId;

  _TextManagementEvent(
    this.title,
    this.body,
    this.localId,
    this.classId,
  );
}

class CreateNewTextEvent extends _TextManagementEvent {
  CreateNewTextEvent(
    String title,
    String body,
    int localId,
    int classId,
  ) : super(title, body, localId, classId);
}

class UpdateTextEvent extends _TextManagementEvent {
  UpdateTextEvent(
    String title,
    String body,
    int localId,
    int classId,
  ) : super(title, body, localId, classId);
}

class DeleteTextEvent extends TextEvent {
  final int localId;

  DeleteTextEvent(
    this.localId,
  );
}

class GetTextEvent extends TextEvent {
  final String title;
  final String body;
  final int localId;
  final int classId;

  GetTextEvent(
    this.title,
    this.body,
    this.localId,
    this.classId,
  );
}

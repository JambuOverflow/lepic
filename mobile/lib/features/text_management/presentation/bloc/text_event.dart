part of 'text_bloc.dart';

@immutable
abstract class TextEvent {
  const TextEvent();
  @override
  List<Object> get props => [];
}

class _TextManagementEvent extends TextEvent {
  final int textId;
  final String text;

  _TextManagementEvent(
    this.textId,
    this.text,
  );
}

class CreateNewTextEvent extends _TextManagementEvent {
  CreateNewTextEvent(
    int textId,
    String text,
  ) : super(textId, text);
}

class UpdateTextEvent extends _TextManagementEvent {
  UpdateTextEvent(
    int textId,
    String text,
  ) : super(textId, text);
}

class DeleteTextEvent extends TextEvent {
  final int textId;

  DeleteTextEvent(
    this.textId,
  );
}

class GetTextEvent extends _TextManagementEvent {
  final int textId;
  final String text;

  GetTextEvent(
    this.textId,
    this.text,
  ) : super(textId, text);
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';


part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  
  final CreateText createText;
  final UpdateText updateText;
  final GetTexts getTexts;
  final DeleteText deleteText;

  TextBloc({
    @required this.createText,
    @required this.updateText,
    @required this.deleteText,
    @required this.getTexts,
  }) : super(TextInitial());

  @override
  Stream<TextState> mapEventToState(
    TextEvent event,
  ) async* {
    if (event is CreateNewTextEvent)
      yield* _createNewTextState(event);
    else if (event is UpdateTextEvent)
      yield* _updateTextState(event);
    else if (event is DeleteTextEvent)
      yield* _deleteTextState(event);
    else if (event is GetTextEvent) yield* _getTextListState(event);
  }

  Stream<TextState> _createNewTextState(CreateNewTextEvent event) async* {
    yield CreatingText();

    final text = _createTextEntityFromEvent(event);

    final failureOrResponse = await createText(TextParams(text: text));

    yield failureOrResponse.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (response) => TextCreated(text: response));
  }

  Stream<TextState> _updateTextState(UpdateTextEvent event) async* {
    yield UpdatingText();

    final text = _createTextEntityFromEvent(event);

    final failureOrResponse = await updateText(TextParams(text: text));

    yield failureOrResponse.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (response) => TextUpdated(text: response));
  }

  Stream<TextState> _deleteTextState(DeleteTextEvent event) async* {
    yield DeletingText();

    final text = Text(
      localId: event.localId,
    );
    final failureOrResponse = await deleteText(TextParams(text: text));

    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => TextDeleted(),
    );
  }

  Stream<TextState> _getTextListState(GetTextEvent event) async* {
    yield GettingTextList();

    final classroom = Classroom(
      id: event.classId,
    );

    final failureOrResponse =
        await getTexts(ClassroomParams(classroom: classroom));
    yield failureOrResponse.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (response) => GotTextList(texts: response),
    );
  }

  Text _createTextEntityFromEvent(TextEvent event) {
    if (event is _TextManagementEvent) {
      return Text(
        title: event.title,
        body: event.body,
        localId: event.localId,
        classId: event.classId,
      );
    }
    throw Exception('Cannot create text from event');
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}

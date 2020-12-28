import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../class_management/domain/entities/classroom.dart';
import '../../../class_management/domain/use_cases/classroom_params.dart';
import '../../domain/entities/text.dart';
import '../../domain/use_cases/create_text_use_case.dart';
import '../../domain/use_cases/delete_text_use_case.dart';
import '../../domain/use_cases/get_texts_use_case.dart';
import '../../domain/use_cases/text_params.dart';
import '../../domain/use_cases/update_text_use_case.dart';

part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  final List<MyText> texts = [];

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
  Stream<TextState> mapEventToState(TextEvent event) async* {
    if (event is CreateTextEvent)
      yield* _createNewTextState(event);
    else if (event is UpdateTextEvent)
      yield* _updateTextState(event);
    else if (event is DeleteTextEvent)
      yield* _deleteTextState(event);
    else if (event is GetTextsEvent) yield* _getTextsState(event);
  }

  Stream<TextState> _createNewTextState(CreateTextEvent event) async* {
    yield CreatingText();

    final text = _createTextEntityFromEvent(event);

    final failureOrText = await createText(TextParams(text: text));

    yield failureOrText.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (newText) => TextCreated(text: newText));
  }

  Stream<TextState> _updateTextState(UpdateTextEvent event) async* {
    yield UpdatingText();

    final text = _updateTextEntityFromEvent(event);

    final failureOrText = await updateText(TextParams(text: text));

    yield failureOrText.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (updatedText) => TextUpdated(text: updatedText));
  }

  Stream<TextState> _deleteTextState(DeleteTextEvent event) async* {
    yield DeletingText();

    final text = MyText(localId: event.localId);

    final failureOrSuccess = await deleteText(TextParams(text: text));

    yield failureOrSuccess.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (_) => TextDeleted(),
    );
  }

  Stream<TextState> _getTextsState(GetTextsEvent event) async* {
    yield GettingTexts();

    final failureOrTexts = await getTexts(
      ClassroomParams(classroom: event.classroom),
    );

    yield failureOrTexts.fold(
      (failure) => Error(message: _mapFailureToMessage(ServerFailure())),
      (texts) {
        texts = texts;
        return TextsGot(texts: texts);
      },
    );
  }

  MyText _createTextEntityFromEvent(CreateTextEvent event) {
    return MyText(
      title: event.title,
      body: event.body,
      classId: event.classroom.id,
    );
  }

  MyText _updateTextEntityFromEvent(UpdateTextEvent event) {
    return MyText(
      title: event.title ?? event.oldText.title,
      body: event.body ?? event.oldText.body,
      classId: event.oldText.classId,
    );
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

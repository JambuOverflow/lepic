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
  final Classroom classroom;
  final CreateText createText;
  final UpdateText updateText;
  final GetTexts getTexts;
  final DeleteText deleteText;

  TextBloc({
    @required this.classroom,
    @required this.createText,
    @required this.updateText,
    @required this.deleteText,
    @required this.getTexts,
  }) : super(GettingTexts());

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

    final text = MyText(
      body: event.body,
      classId: event.classroom.id,
      title: event.title,
    );

    final failureOrText = await createText(TextParams(text: text));

    yield failureOrText.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (newText) => TextCreated(text: newText));
  }

  Stream<TextState> _updateTextState(UpdateTextEvent event) async* {
    yield UpdatingText();

    final failureOrText = await updateText(TextParams(text: event.oldText));

    yield failureOrText.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (updatedText) => TextUpdated(text: updatedText));
  }

  Stream<TextState> _deleteTextState(DeleteTextEvent event) async* {
    yield DeletingText();

    final failureOrSuccess = await deleteText(TextParams(text: event.text));

    yield failureOrSuccess.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (_) => TextDeleted(),
    );
  }

  Stream<TextState> _getTextsState(GetTextsEvent event) async* {
    yield GettingTexts();

    final failureOrTexts =
        await getTexts(ClassroomParams(classroom: classroom));

    yield failureOrTexts.fold(
      (failure) => Error(message: _mapFailureToMessage(CacheFailure())),
      (texts) => TextsGot(texts: texts),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      case CacheFailure:
        return 'Error on local storage';
      default:
        return 'Unexpected Error';
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../class_management/domain/entities/classroom.dart';
import '../../../class_management/domain/use_cases/classroom_params.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/text.dart';
import '../../domain/use_cases/create_text_use_case.dart';
import '../../domain/use_cases/delete_text_use_case.dart';
import '../../domain/use_cases/get_texts_of_classroom_use_case.dart';
import '../../domain/use_cases/text_params.dart';
import '../../domain/use_cases/update_text_use_case.dart';

part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  List<MyText> texts = const <MyText>[];

  final Classroom classroom;

  final CreateText createText;
  final UpdateText updateText;
  final GetTextsOfClassroom getTextsOfClassroom;
  final DeleteText deleteText;

  TextBloc({
    @required this.classroom,
    @required this.createText,
    @required this.updateText,
    @required this.deleteText,
    @required this.getTextsOfClassroom,
  }) : super(TextsLoadInProgress());

  @override
  Stream<TextState> mapEventToState(TextEvent event) async* {
    if (event is CreateTextEvent)
      yield* _createTextState(event);
    else if (event is UpdateTextEvent)
      yield* _updateTextState(event);
    else if (event is DeleteTextEvent)
      yield* _deleteTextState(event);
    else if (event is GetTextsEvent) yield* _getTextsState();
  }

  Stream<TextState> _createTextState(CreateTextEvent event) async* {
    final text = MyText(
      title: event.title,
      body: event.body,
      classId: classroom.id,
    );

    final failureOrSuccess = await createText(TextParams(text: text));

    yield* _eitherLoadedOrErrorState(failureOrSuccess);
  }

  Stream<TextState> _eitherLoadedOrErrorState(
    Either<Failure, dynamic> failureOrSuccess,
  ) async* {
    yield* failureOrSuccess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(failure));
      },
      (_) async* {
        yield* _loadAndReplaceClassrooms();
      },
    );
  }

  Stream<TextState> _deleteTextState(DeleteTextEvent event) async* {
    final failureOrSuccess = await deleteText(TextParams(text: event.text));

    yield* failureOrSuccess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(CacheFailure()));
      },
      (_) async* {
        yield* _loadAndReplaceClassrooms();
      },
    );
  }

  Stream<TextState> _updateTextState(UpdateTextEvent event) async* {
    final updatedText = MyText(
      title: event.title,
      body: event.body,
      localId: event.oldText.localId,
      classId: classroom.id,
    );

    final failureOrClassroom = await updateText(TextParams(text: updatedText));

    yield* _eitherLoadedOrErrorState(failureOrClassroom);
  }

  Stream<TextState> _getTextsState() async* {
    yield TextsLoadInProgress();

    yield* _loadAndReplaceClassrooms();
  }

  Stream<TextState> _loadAndReplaceClassrooms() async* {
    final failureOrClassrooms = await getTextsOfClassroom(
      ClassroomParams(classroom: classroom),
    );

    yield failureOrClassrooms.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (texts) {
        this.texts = texts;

        return TextsLoaded(texts);
      },
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

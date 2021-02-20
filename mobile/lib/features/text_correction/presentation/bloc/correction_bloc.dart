import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/use_cases/correction_params.dart';
import '../../domain/use_cases/create_correction_use_case.dart';
import '../../domain/use_cases/delete_correction_use_case.dart';
import '../../domain/use_cases/update_correction_use_case.dart';
import '../../domain/entities/correction.dart';
import '../../../text_management/domain/entities/text.dart';
import '../../../student_management/domain/entities/student.dart';
import '../../domain/use_cases/get_correction_use_case.dart';
import '../../domain/entities/mistake.dart';

part 'correction_event.dart';
part 'correction_state.dart';

class CorrectionBloc extends Bloc<CorrectionEvent, CorrectionState> {
  final GetCorrectionUseCase getCorrectionUseCase;
  final CreateCorrectionUseCase createCorrectionUseCase;
  final DeleteCorrectionUseCase deleteCorrectionUseCase;
  final UpdateCorrectionUseCase updateCorrectionUseCase;

  final MyText text;
  final Student student;

  final Map<int, Mistake> indexToMistakes = {};
  final Map<int, String> indexToWord = {};

  List<Mistake> get mistakes => indexToMistakes.values.toList();
  Correction get _correction => Correction(
        textId: text.localId,
        studentId: student.id,
        mistakes: mistakes,
      );

  CorrectionBloc({
    @required this.text,
    @required this.student,
    @required this.getCorrectionUseCase,
    @required this.createCorrectionUseCase,
    @required this.deleteCorrectionUseCase,
    @required this.updateCorrectionUseCase,
  }) : super(CorrectionLoading()) {
    _buildIndexToWordMap(text);
  }

  void clearMistakes() => indexToMistakes.clear();

  @override
  Stream<CorrectionState> mapEventToState(
    CorrectionEvent event,
  ) async* {
    if (event is HighlightEvent) {
      yield* _addHighlightMistakeAndYieldState(event);
    } else if (event is CommentEvent) {
      yield* _addCommentedMistakeAndYieldState(event);
    } else if (event is RemoveMistakeEvent) {
      yield* _removeMistakeAndYieldState(event);
    } else if (event is LoadCorrectionEvent) {
      yield* _loadCorrectionState();
    } else if (event is FinishCorrectionEvent) {
      yield* _createCorrectionAndYieldState();
    } else if (event is UpdateCorrectionEvent) {
      yield* _updateCorrectionState();
    } else if (event is DeleteCorrectionEvent) {
      yield* _deleteCorrectionState();
    }
  }

  Stream<CorrectionState> _addCommentedMistakeAndYieldState(
      CommentEvent event) async* {
    final mistake = Mistake(
      wordIndex: event.wordIndex,
      commentary: event.commentary,
    );

    yield* _addMistakeAndYieldState(mistake);
  }

  Stream<CorrectionState> _addHighlightMistakeAndYieldState(
      HighlightEvent event) async* {
    final mistake = Mistake.highlighted(wordIndex: event.wordIndex);

    yield* _addMistakeAndYieldState(mistake);
  }

  Stream<CorrectionState> _removeMistakeAndYieldState(
      RemoveMistakeEvent event) async* {
    indexToMistakes.remove(event.wordIndex);

    yield CorrectionLoaded(_correction);
  }

  Stream<CorrectionState> _loadCorrectionState() async* {
    final getOrFailure = await getCorrectionUseCase(
      StudentTextParams(text: text, student: student),
    );

    yield getOrFailure.fold(
      (failure) => CorrectionLoadingError(),
      (correction) {
        _populateMistakeMapWith(correction);
        return CorrectionLoaded(correction);
      },
    );
  }

  void _populateMistakeMapWith(Correction correction) {
    correction.mistakes.forEach(
      (mistake) => indexToMistakes[mistake.wordIndex] = mistake,
    );
  }

  Stream<CorrectionState> _createCorrectionAndYieldState() async* {
    final correctionEither = await createCorrectionUseCase(
      CorrectionParams(correction: _correction),
    );

    yield correctionEither.fold(
      (failure) => CorrectionLoadingError(),
      (correction) => CorrectionLoaded(correction),
    );
  }

  Stream<CorrectionState> _updateCorrectionState() async* {
    final updateOrFailure = await updateCorrectionUseCase(
      CorrectionParams(correction: _correction),
    );

    yield updateOrFailure.fold(
      (failure) => CorrectionLoadingError(),
      (updatedCorrection) => CorrectionLoaded(updatedCorrection),
    );
  }

  Stream<CorrectionState> _deleteCorrectionState() async* {
    final deleteOrFailure = await deleteCorrectionUseCase(
      CorrectionParams(correction: _correction),
    );

    yield deleteOrFailure.fold(
      (failure) => CorrectionDeletionError(),
      (success) {
        indexToMistakes.clear();
        return CorrectionLoaded(_correction);
      },
    );
  }

  Stream<CorrectionState> _addMistakeAndYieldState(Mistake mistake) async* {
    indexToMistakes[mistake.wordIndex] = mistake;

    yield CorrectionLoaded(_correction);
  }

  void _buildIndexToWordMap(MyText text) {
    final splittedText = text.body.split(" ");

    for (int i = 0; i < splittedText.length; i++)
      indexToWord[i] = splittedText[i];
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/use_cases/create_correction_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/delete_correction_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/update_correction_use_case.dart';
import 'package:mobile/features/text_correction/presentation/bloc/correction_bloc.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class MockCreateCorrectionUseCase extends Mock
    implements CreateCorrectionUseCase {}

class MockDeleteCorrectionUseCase extends Mock
    implements DeleteCorrectionUseCase {}

class MockUpdateCorrectionUseCase extends Mock
    implements UpdateCorrectionUseCase {}

class MockGetCorrectionUseCase extends Mock implements GetCorrectionUseCase {}

void main() {
  CorrectionBloc bloc;
  MockCreateCorrectionUseCase mockCreateCorrection;
  MockUpdateCorrectionUseCase mockUpdateCorrection;
  MockDeleteCorrectionUseCase mockDeleteCorrection;
  MockGetCorrectionUseCase mockGetCorrection;

  final tCorrection = Correction(
    textId: 1,
    studentId: 1,
    mistakes: <Mistake>[],
  );

  final tText = MyText(
    title: 'Title',
    body: 'a b c',
    localId: 001,
    studentId: 010,
  );

  final tStudent = Student(
    firstName: 'c',
    lastName: 'c',
    id: 1,
    classroomId: 1,
  );

  setUp(() {
    mockCreateCorrection = MockCreateCorrectionUseCase();
    mockUpdateCorrection = MockUpdateCorrectionUseCase();
    mockDeleteCorrection = MockDeleteCorrectionUseCase();
    mockGetCorrection = MockGetCorrectionUseCase();

    bloc = CorrectionBloc(
      createCorrectionUseCase: mockCreateCorrection,
      updateCorrectionUseCase: mockUpdateCorrection,
      getCorrectionUseCase: mockGetCorrection,
      deleteCorrectionUseCase: mockDeleteCorrection,
      student: tStudent,
      text: tText,
    );
  });

  test('initial state should be [CorrectionLoading]', () {
    expect(bloc.state, CorrectionLoading());
  });

  test('indexToWord should contain correct value-key pairs', () {
    expect(bloc.indexToWord, <int, String>{0: 'a', 1: 'b', 2: 'c'});
  });

  group('highlight', () {
    final firstIndex = 0;
    final tCorrectionMistake = Correction(
      textId: 1,
      studentId: 1,
      mistakes: <Mistake>[Mistake.highlighted(wordIndex: firstIndex)],
    );

    blocTest(
      'add mistake to index-mistake map and emit [CorrectionLoaded]',
      build: () => bloc,
      act: (bloc) => bloc.add(HighlightEvent(wordIndex: firstIndex)),
      verify: (bloc) => bloc.indexToMistakes[firstIndex].isHighlighted,
      expect: [CorrectionInProgress(tCorrectionMistake)],
    );
  });

  group('comment', () {
    final firstIndex = 0;
    final tComment = 'hello';
    final tCorrectionMistake = Correction(
      textId: 1,
      studentId: 1,
      mistakes: <Mistake>[Mistake(wordIndex: firstIndex, commentary: tComment)],
    );

    blocTest(
      'add mistake to index-mistake map and emit [CorrectionLoaded]',
      build: () => bloc,
      act: (bloc) => bloc.add(CommentEvent(
        wordIndex: firstIndex,
        commentary: tComment,
      )),
      verify: (bloc) => bloc.indexToMistakes[firstIndex].hasCommentary,
      expect: [CorrectionInProgress(tCorrectionMistake)],
    );
  });

  group('removeMistake', () {
    final firstIndex = 0;

    blocTest(
      'remove mistake from index-mistake map and emit [CorrectionLoaded]',
      build: () => bloc,
      act: (bloc) {
        bloc.add(HighlightEvent(wordIndex: firstIndex));
        return bloc.add(RemoveMistakeEvent(wordIndex: firstIndex));
      },
      skip: 1,
      verify: (bloc) => bloc.indexToMistakes[firstIndex] == null,
      expect: [CorrectionInProgress(tCorrection)],
    );
  });

  group('finishCorrection', () {
    blocTest(
      'should emit [CorrectionLoaded] when correction creation is successful',
      build: () {
        when(mockCreateCorrection(any)).thenAnswer(
          (_) async => Right(tCorrection),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FinishCorrectionEvent()),
      expect: [CorrectionLoaded(tCorrection)],
    );

    blocTest(
      'should emit [CorrectionLoadingError] when correction creation is unsuccessful',
      build: () {
        when(mockCreateCorrection(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FinishCorrectionEvent()),
      expect: [CorrectionLoadingError()],
    );
  });

  group('loadCorrection', () {
    final firstIndex = 0;
    final tCorrectionMistake = Correction(
      textId: 1,
      studentId: 1,
      mistakes: <Mistake>[Mistake.highlighted(wordIndex: firstIndex)],
    );

    blocTest(
      'should emit [CorrectionLoaded] when correction load is successful',
      build: () {
        when(mockGetCorrection(any)).thenAnswer(
          (_) async => Right(tCorrectionMistake),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCorrectionEvent()),
      expect: [CorrectionLoaded(tCorrectionMistake)],
      verify: (bloc) =>
          bloc.indexToMistakes ==
          {0: Mistake.highlighted(wordIndex: firstIndex)},
    );

    blocTest(
      'should emit [CorrectionLoadingError] when correction load is unsuccessful',
      build: () {
        when(mockGetCorrection(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCorrectionEvent()),
      expect: [CorrectionLoadingError()],
    );
  });

  group('updateCorrection', () {
    blocTest(
      'should emit [CorrectionLoaded] when correction update is successful',
      build: () {
        when(mockUpdateCorrection(any)).thenAnswer(
          (_) async => Right(tCorrection),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateCorrectionEvent()),
      expect: [CorrectionLoaded(tCorrection)],
    );

    blocTest(
      'should emit [CorrectionLoadingError] when correction update is unsuccessful',
      build: () {
        when(mockUpdateCorrection(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateCorrectionEvent()),
      expect: [CorrectionLoadingError()],
    );
  });

  group('deleteCorrection', () {
    blocTest(
      'should emit [CorrectionLoaded] when correction deletion is successful',
      build: () {
        when(mockDeleteCorrection(any)).thenAnswer((_) async => Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteCorrectionEvent()),
      expect: [CorrectionLoaded(tCorrection)],
    );

    blocTest(
      'should emit [CorrectionLoadingError] when correction deletion is unsuccessful',
      build: () {
        when(mockDeleteCorrection(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteCorrectionEvent()),
      expect: [CorrectionDeletionError()],
    );
  });
}

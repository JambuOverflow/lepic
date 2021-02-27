import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/correction_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/student_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/data/data_sources/mistake_local_data_source.dart';
import 'package:mobile/features/text_correction/data/repositories/correction_repository_impl.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockMistakeLocalDataSource extends Mock
    implements MistakeLocalDataSource {}

class MockTextEntityModelConverter extends Mock
    implements TextEntityModelConverter {}

class MockStudentEntityModelConverter extends Mock
    implements StudentEntityModelConverter {}

void main() {
  MockMistakeLocalDataSource mockLocalDataSource;
  MistakeEntityModelConverter mistakeEntityModelConverter;
  CorrectionEntityModelConverter correctionEntityModelConverter;
  MockTextEntityModelConverter mockTextEntityModelConverter;
  MockStudentEntityModelConverter mockStudentEntityModelConverter;
  CorrectionRepositoryImpl repository;

  final tMistakeInput1 = Mistake(
    wordIndex: 1,
    commentary: "",
  );

  final tMistakeOutput1 = Mistake(
    wordIndex: 1,
    commentary: "",
    localId: 1,
  );

  final tMistakeInput2 = Mistake(
    wordIndex: 10,
    commentary: "",
  );

  final tMistakeOutput2 = Mistake(
    wordIndex: 10,
    commentary: "",
    localId: 2,
  );

  final tCorrectionInput = Correction(
    textId: 1,
    studentId: 1,
    mistakes: [
      tMistakeInput1,
      tMistakeInput2,
    ],
  );

  final tCorrectionOutput = Correction(
    localId: 1,
    textId: 1,
    studentId: 1,
    mistakes: [
      tMistakeOutput1,
      tMistakeOutput2,
    ],
  );

  final tCorrectionModelInput1 = CorrectionModel(
    textId: 1,
    studentId: 1,
  );

  final tCorrectionModelOutput1 = CorrectionModel(
    textId: 1,
    studentId: 1,
    localId: 1,
  );

  final tMistakeModelInput1 = MistakeModel(
    wordIndex: 1,
    commentary: "",
    correctionId: 1,
  );

  final tMistakeModelInput2 = MistakeModel(
    wordIndex: 10,
    commentary: "",
    correctionId: 1,
  );

  final text = MyText(
    localId: 1,
    studentId: 1,
    body: "",
    title: "",
  );

  final textModel = TextModel(
    localId: 1,
    studentId: 1,
    body: "",
    title: "",
    tutorId: 1,
  );

  final student = Student(
    firstName: "",
    lastName: "",
    classroomId: 1,
    id: 1,
  );

  final studentModel = StudentModel(
    firstName: "",
    lastName: "",
    classroomId: 1,
    localId: 1,
  );

  final tMistakeModelOutput1 = tMistakeModelInput1.copyWith(localId: 1);

  final tMistakeModelOutput2 = tMistakeModelInput2.copyWith(localId: 2);

  final tMistakeModelsInput = [tMistakeModelInput1, tMistakeModelInput2];

  final tMistakeModelsOutput = [tMistakeModelOutput1, tMistakeModelOutput2];

  setUp(() async {
    mockLocalDataSource = MockMistakeLocalDataSource();
    mistakeEntityModelConverter = MistakeEntityModelConverter();
    correctionEntityModelConverter = CorrectionEntityModelConverter();
    mockTextEntityModelConverter = MockTextEntityModelConverter();
    mockStudentEntityModelConverter = MockStudentEntityModelConverter();

    repository = CorrectionRepositoryImpl(
        localDataSource: mockLocalDataSource,
        mistakeEntityModelConverter: mistakeEntityModelConverter,
        textEntityModelConverter: mockTextEntityModelConverter,
        correctionEntityModelConverter: correctionEntityModelConverter,
        studentEntityModelConverter: mockStudentEntityModelConverter);
  });

  group('createCorrection', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewCorrection(tCorrectionModelInput1))
          .thenThrow(CacheException());

      final result = await repository.createCorrection(tCorrectionInput);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created correction', () async {
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput1))
          .thenAnswer((_) async => tMistakeModelOutput1);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput2))
          .thenAnswer((_) async => tMistakeModelOutput2);
      when(mockLocalDataSource.cacheNewCorrection(tCorrectionModelInput1))
          .thenAnswer((_) async => tCorrectionModelOutput1);

      final result = await repository.createCorrection(tCorrectionInput);

      verifyInOrder([
        mockLocalDataSource.cacheNewCorrection(tCorrectionModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput2),
      ]);
      verifyNoMoreInteractions(mockLocalDataSource);

      result.fold((l) => null, (r) {
        expect(r.localId, tCorrectionOutput.localId);
        expect(r.studentId, tCorrectionOutput.studentId);
        expect(r.textId, tCorrectionOutput.textId);
        equals(listEquals(r.mistakes, tCorrectionOutput.mistakes));
      });
    });
  });

  group('deleteCorrection', () {
    test('should delete a correction', () async {
      when(mockLocalDataSource
              .deleteCorrectionFromCache(tCorrectionModelOutput1))
          .thenAnswer((_) => null);

      await repository.deleteCorrection(tCorrectionOutput);

      verifyInOrder([
        mockLocalDataSource.deleteCorrectionFromCache(tCorrectionModelOutput1),
      ]);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionFromCache(tCorrectionModelOutput1))
          .thenThrow(CacheException());

      final result = await repository.deleteCorrection(tCorrectionOutput);
      verify(mockLocalDataSource
          .deleteCorrectionFromCache(tCorrectionModelOutput1));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('updateCorrection', () {
    test('should return a correction when updateCorrection is called',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionFromCache(tCorrectionModelOutput1))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelOutput1))
          .thenAnswer((_) async => tMistakeModelOutput1);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelOutput2))
          .thenAnswer((_) async => tMistakeModelOutput2);
      when(mockLocalDataSource.cacheNewCorrection(tCorrectionModelOutput1))
          .thenAnswer((_) async => tCorrectionModelOutput1);

      final result = await repository.updateCorrection(tCorrectionOutput);

      verifyInOrder([
        mockLocalDataSource.deleteCorrectionFromCache(tCorrectionModelOutput1),
        mockLocalDataSource.cacheNewCorrection(tCorrectionModelOutput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelOutput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelOutput2),
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionFromCache(tCorrectionModelOutput1))
          .thenThrow(CacheException());

      final result = await repository.updateCorrection(tCorrectionOutput);

      verifyInOrder([
        mockLocalDataSource.deleteCorrectionFromCache(tCorrectionModelOutput1),
      ]);
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionFromCache(tCorrectionModelOutput1))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.cacheNewCorrection(tCorrectionModelOutput1))
          .thenThrow(CacheException());

      final result = await repository.updateCorrection(tCorrectionOutput);

      verifyInOrder([
        mockLocalDataSource.deleteCorrectionFromCache(tCorrectionModelOutput1),
        mockLocalDataSource.cacheNewCorrection(tCorrectionModelOutput1),
      ]);
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getCorrections', () {
    test('should return a list of corrections when getCorrections is called',
        () async {
      when(mockLocalDataSource.getCorrectionFromCache(
              studentModel: studentModel, textModel: textModel))
          .thenAnswer((_) async => tCorrectionModelOutput1);
      when(mockLocalDataSource.getMistakesFromCache(tCorrectionModelOutput1))
          .thenAnswer((_) async => tMistakeModelsOutput);
      when(mockTextEntityModelConverter.mytextEntityToModel(text))
          .thenAnswer((_) async => textModel);
      when(mockStudentEntityModelConverter.entityToModel(student))
          .thenAnswer((_) async => studentModel);

      final result =
          await repository.getCorrection(student: student, text: text);

      verifyInOrder([
        mockStudentEntityModelConverter.entityToModel(student),
        mockTextEntityModelConverter.mytextEntityToModel(text),
        mockLocalDataSource.getCorrectionFromCache(
            studentModel: studentModel, textModel: textModel),
        mockLocalDataSource.getMistakesFromCache(tCorrectionModelOutput1)
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a EmptyDataFailure when a EmptyDataException is throw',
        () async {
      when(mockLocalDataSource.getCorrectionFromCache(
              studentModel: studentModel, textModel: textModel))
          .thenThrow(EmptyDataException());
      when(mockTextEntityModelConverter.mytextEntityToModel(text))
          .thenAnswer((_) async => textModel);
      when(mockStudentEntityModelConverter.entityToModel(student))
          .thenAnswer((_) async => studentModel);

      final result =
          await repository.getCorrection(student: student, text: text);

      verifyInOrder([
        mockStudentEntityModelConverter.entityToModel(student),
        mockTextEntityModelConverter.mytextEntityToModel(text),
        mockLocalDataSource.getCorrectionFromCache(
            studentModel: studentModel, textModel: textModel),
      ]);
      expect(result, Left(EmptyDataFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getCorrectionsOfStudent', () {
    test('should return a list of corrections when getCorrections is called',
        () async {
      when(mockLocalDataSource
              .getAllCorrectionsOfStudentFromCache(studentModel))
          .thenAnswer((_) async => [tCorrectionModelOutput1]);
      when(mockLocalDataSource.getMistakesFromCache(tCorrectionModelOutput1))
          .thenAnswer((_) async => tMistakeModelsOutput);
      when(mockStudentEntityModelConverter.entityToModel(student))
          .thenAnswer((_) async => studentModel);

      final result = await repository.getAllCorrectionsOfStudent(student);

      verifyInOrder([
        mockStudentEntityModelConverter.entityToModel(student),
        mockLocalDataSource.getAllCorrectionsOfStudentFromCache(studentModel),
        mockLocalDataSource.getMistakesFromCache(tCorrectionModelOutput1)
      ]);
      result.fold((l) => expect(false, true), (r) {
        expect(true, listEquals(r, [tCorrectionOutput]));
      });
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a EmptyDataFailure when a EmptyDataException is throw',
        () async {
      when(mockLocalDataSource.getCorrectionFromCache(
              studentModel: studentModel, textModel: textModel))
          .thenThrow(EmptyDataException());
      when(mockTextEntityModelConverter.mytextEntityToModel(text))
          .thenAnswer((_) async => textModel);
      when(mockStudentEntityModelConverter.entityToModel(student))
          .thenAnswer((_) async => studentModel);

      final result =
          await repository.getCorrection(student: student, text: text);

      verifyInOrder([
        mockStudentEntityModelConverter.entityToModel(student),
        mockTextEntityModelConverter.mytextEntityToModel(text),
        mockLocalDataSource.getCorrectionFromCache(
            studentModel: studentModel, textModel: textModel),
      ]);
      expect(result, Left(EmptyDataFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getCorrectionsFromId', () {
    test('should return a list of corrections when getCorrections is called',
        () async {
      when(mockLocalDataSource.getCorrectionFromCacheUsingId(
              studentId: 1, textId: 1))
          .thenAnswer((_) async => tCorrectionModelOutput1);
      when(mockTextEntityModelConverter.mytextEntityToModel(text))
          .thenAnswer((_) async => textModel);
      when(mockStudentEntityModelConverter.entityToModel(student))
          .thenAnswer((_) async => studentModel);
      when(mockLocalDataSource.getMistakesFromCacheUsingId(1))
          .thenAnswer((_) async => tMistakeModelsOutput);

      final result =
          await repository.getCorrectionFromId(studentId: 1, textId: 1);

      verifyInOrder([
        mockLocalDataSource.getCorrectionFromCacheUsingId(
            studentId: 1, textId: 1),
        mockLocalDataSource.getMistakesFromCacheUsingId(1)
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a EmptyDataFailure when a EmptyDataException is throw',
        () async {
      when(mockLocalDataSource.getCorrectionFromCacheUsingId(
              studentId: 1, textId: 1))
          .thenThrow(EmptyDataException());

      final result =
          await repository.getCorrectionFromId(studentId: 1, textId: 1);

      verifyInOrder([
        mockLocalDataSource.getCorrectionFromCacheUsingId(
            studentId: 1, textId: 1),
      ]);
      expect(result, Left(EmptyDataFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}

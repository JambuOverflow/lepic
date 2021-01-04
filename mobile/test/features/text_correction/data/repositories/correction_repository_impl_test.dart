import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/data/data_sources/mistake_local_data_source.dart';
import 'package:mobile/features/text_correction/data/repositories/correction_repository_impl.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockMistakeLocalDataSource extends Mock
    implements MistakeLocalDataSource {}

class MockMistakeEntityModelConverter extends Mock
    implements MistakeEntityModelConverter {}

class MockTextEntityModelConverter extends Mock
    implements TextEntityModelConverter {}

void main() {
  MockMistakeLocalDataSource mockLocalDataSource;
  MockMistakeEntityModelConverter mockMistakeEntityModelConverter;
  MockTextEntityModelConverter mockTextEntityModelConverter;
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
    textId: 1,
    studentId: 1,
    mistakes: [
      tMistakeOutput1,
      tMistakeOutput2,
    ],
  );

  final tMistakeModelInput1 = MistakeModel(
    wordIndex: 1,
    commentary: "",
    studentId: 1,
    textId: 1,
  );

  final tMistakeModelInput2 = MistakeModel(
    wordIndex: 10,
    commentary: "",
    studentId: 1,
    textId: 1,
  );

  final text = MyText(
    localId: 1,
    classId: 1,
    body: "",
    title: "",
  );

  final textModel = TextModel(
    localId: 1,
    classId: 1,
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
    mockMistakeEntityModelConverter = MockMistakeEntityModelConverter();
    mockTextEntityModelConverter = MockTextEntityModelConverter();

    repository = CorrectionRepositoryImpl(
        localDataSource: mockLocalDataSource,
        mistakeEntityModelConverter: mockMistakeEntityModelConverter,
        textEntityModelConverter: mockTextEntityModelConverter);

    when(mockMistakeEntityModelConverter.entityToModel(tCorrectionInput))
        .thenAnswer((_) => tMistakeModelsInput);
    when(mockMistakeEntityModelConverter
            .entityToModel(tCorrectionOutput))
        .thenAnswer((_) => tMistakeModelsOutput);
    when(mockMistakeEntityModelConverter
            .modelToEntity(tMistakeModelsOutput))
        .thenAnswer((_) => tCorrectionOutput);
  });

  group('createCorrection', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput1))
          .thenThrow(CacheException());

      final result = await repository.createCorrection(tCorrectionInput);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created correction', () async {
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput1))
          .thenAnswer((_) async => tMistakeModelOutput1);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput2))
          .thenAnswer((_) async => tMistakeModelOutput2);

      final result = await repository.createCorrection(tCorrectionInput);

      verifyInOrder([
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput2),
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('deleteCorrection', () {
    test('should delete a correction', () async {
      when(mockLocalDataSource
              .deleteCorrectionMistakesFromCache(tMistakeModelOutput1))
          .thenAnswer((_) => null);

      await repository.deleteCorrection(tCorrectionOutput);

      verifyInOrder([
        mockLocalDataSource
            .deleteCorrectionMistakesFromCache(tMistakeModelOutput1),
      ]);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionMistakesFromCache(tMistakeModelOutput1))
          .thenThrow(CacheException());

      final result = await repository.deleteCorrection(tCorrectionOutput);
      verify(mockLocalDataSource
          .deleteCorrectionMistakesFromCache(tMistakeModelOutput1));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('updateCorrection', () {
    test('should return a correction when updateCorrection is called',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionMistakesFromCache(tMistakeModelInput1))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput1))
          .thenAnswer((_) async => tMistakeModelOutput1);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput2))
          .thenAnswer((_) async => tMistakeModelOutput2);

      final result = await repository.updateCorrection(tCorrectionInput);

      verifyInOrder([
        mockLocalDataSource
            .deleteCorrectionMistakesFromCache(tMistakeModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput2),
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionMistakesFromCache(tMistakeModelInput1))
          .thenThrow(CacheException());

      final result = await repository.updateCorrection(tCorrectionInput);

      verifyInOrder([
        mockLocalDataSource
            .deleteCorrectionMistakesFromCache(tMistakeModelInput1),
      ]);
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource
              .deleteCorrectionMistakesFromCache(tMistakeModelInput1))
          .thenAnswer((_) async => null);
      when(mockLocalDataSource.cacheNewMistake(tMistakeModelInput1))
          .thenThrow(CacheException());

      final result = await repository.updateCorrection(tCorrectionInput);

      verifyInOrder([
        mockLocalDataSource
            .deleteCorrectionMistakesFromCache(tMistakeModelInput1),
        mockLocalDataSource.cacheNewMistake(tMistakeModelInput1),
      ]);
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getCorrections', () {
    test('should return a list of corrections when getCorrections is called',
        () async {
      when(mockLocalDataSource.getCorrectionMistakesFromCache(
              studentModel: studentModel, textModel: textModel))
          .thenAnswer((_) async => tMistakeModelsOutput);
      when(mockTextEntityModelConverter.mytextEntityToModel(text)).thenAnswer((_) async => textModel);

      final result =
          await repository.getCorrection(student: student, text: text);

      verifyInOrder([
        mockTextEntityModelConverter.mytextEntityToModel(text),
        mockLocalDataSource.getCorrectionMistakesFromCache(
              studentModel: studentModel, textModel: textModel),
        
      ]);
      expect(result, Right(tCorrectionOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
    

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getCorrectionMistakesFromCache(
              studentModel: studentModel, textModel: textModel))
          .thenThrow(CacheException());
      when(mockTextEntityModelConverter.mytextEntityToModel(text)).thenAnswer((_) async => textModel);

      final result =
          await repository.getCorrection(student: student, text: text);

      verifyInOrder([
        mockTextEntityModelConverter.mytextEntityToModel(text),
        mockLocalDataSource.getCorrectionMistakesFromCache(
              studentModel:studentModel, textModel: textModel),
        
      ]);
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
    
  });
}

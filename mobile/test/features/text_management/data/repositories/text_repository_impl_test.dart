import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/student_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockTextLocalDataSource extends Mock implements TextLocalDataSource {}

class MockTextEntityModelConverter extends Mock
    implements TextEntityModelConverter {}

class MockStudentEntityModelConverter extends Mock
    implements StudentEntityModelConverter {}

void main() {
  MockTextLocalDataSource mockLocalDataSource;
  TextRepositoryImpl repository;
  MockTextEntityModelConverter mockTextEntityModelConverter;
  MockStudentEntityModelConverter mockStudentEntityModelConverter;

  StudentModel tStudentModel;
  final tStudent = Student(firstName: 'a', lastName: 'b', classroomId: 1);

  final tText = MyText(
    title: "a",
    body: "b",
    studentId: 1,
    localId: 1,
    creationDate: DateTime(2020),
  );

  final tTextModelInput = TextModel(
    title: "a",
    body: "b",
    studentId: 1,
    tutorId: 1,
    localId: 1,
    creationDate: DateTime(2020),
  );

  final tTextOutput = MyText(
    title: "a",
    body: "b",
    studentId: 1,
    localId: 1,
    creationDate: DateTime(2020),

  );

  final tTextModelOutput = tTextModelInput.copyWith(localId: 1);

  final tTextsModels = [tTextModelInput, tTextModelInput];
  final tTexts = [tText, tText];

  setUp(() {
    mockLocalDataSource = MockTextLocalDataSource();
    mockTextEntityModelConverter = MockTextEntityModelConverter();
    mockStudentEntityModelConverter = MockStudentEntityModelConverter();

    tStudentModel = StudentModel(
      localId: 1,
      firstName: 'a',
      lastName: 'b',
      classroomId: 1,
    );

    repository = TextRepositoryImpl(
      localDataSource: mockLocalDataSource,
      textEntityModelConverter: mockTextEntityModelConverter,
      studentEntityModelConverter: mockStudentEntityModelConverter,
    );
    when(mockTextEntityModelConverter.mytextEntityToModel(tText))
        .thenAnswer((_) async => tTextModelInput);
    when(mockTextEntityModelConverter.mytextModelToEntity(tTextModelOutput))
        .thenAnswer((_) => tText);
    when(mockStudentEntityModelConverter.entityToModel(tStudent))
        .thenAnswer((_) async => tStudentModel);
  });

  group('createText', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewText(tTextModelInput))
          .thenThrow(CacheException());

      final result = await repository.createText(tText);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created text', () async {
      when(mockLocalDataSource.cacheNewText(tTextModelInput))
          .thenAnswer((_) async => tTextModelOutput);

      final result = await repository.createText(tText);

      verify(mockLocalDataSource.cacheNewText(tTextModelInput));
      expect(result, Right(tText));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('delete', () {
    test('should delete a text and return Right', () async {
      when(mockLocalDataSource.deleteTextFromCache(tTextModelInput))
          .thenAnswer((_) async => Right(null));

      final expected = await repository.deleteText(tText);

      expect(expected, Right(null));

      verify(mockLocalDataSource.deleteTextFromCache(tTextModelInput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteTextFromCache(tTextModelInput))
          .thenThrow(CacheException());

      final result = await repository.deleteText(tText);
      verify(mockLocalDataSource.deleteTextFromCache(tTextModelInput));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('update', () {
    test('should return a text when updateText is called', () async {
      when(mockLocalDataSource.updateCachedText(tTextModelInput))
          .thenAnswer((_) async => tTextModelOutput);

      final result = await repository.updateText(tText);

      verify(mockLocalDataSource.updateCachedText(tTextModelInput));
      expect(result, Right(tTextOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedText(tTextModelInput))
          .thenThrow(CacheException());

      final result = await repository.updateText(tText);

      verify(mockLocalDataSource.updateCachedText(tTextModelInput));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getTextsOfClassroom', () {
    test('should return a list of texts when getTextsofClassroom is called',
        () async {
      when(mockLocalDataSource.getStudentTextsFromCache(tStudentModel))
          .thenAnswer((_) async => tTextsModels);

      final result = await repository.getStudentTexts(tStudent);
      final List<MyText> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tTexts);
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getStudentTextsFromCache(tStudentModel))
          .thenThrow(CacheException());

      final result = await repository.getStudentTexts(tStudent);

      expect(result, Left(CacheFailure()));
    });
  });

  group('getTexts', () {
    test('should return a list of texts when getTexts is called', () async {
      when(mockLocalDataSource.getAllUserTextsFromCache())
          .thenAnswer((_) async => tTextsModels);

      final result = await repository.getAllUserTexts();
      final List<MyText> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tTexts);
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getAllUserTextsFromCache())
          .thenThrow(CacheException());

      final result = await repository.getAllUserTexts();

      expect(result, Left(CacheFailure()));
    });
  });

  group('getText', () {
    test('should return a text when getText is called', () async {
      when(mockLocalDataSource.getTextFromCache(1))
          .thenAnswer((_) async => tTextModelOutput);

      final result = await repository.getTextByID(1);

      expect(result, Right(tTextOutput));
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getTextFromCache(1)).thenThrow(CacheException());

      final result = await repository.getTextByID(1);

      expect(result, Left(CacheFailure()));
    });
  });
}

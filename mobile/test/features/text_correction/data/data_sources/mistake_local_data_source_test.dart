import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/text_correction/data/data_sources/mistake_local_data_source.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockDatabase mockDatabase;
  MistakeLocalDataSourceImpl mistakeLocalDataSourceImpl;

  final tValidPk = 1;

  final studentModel = StudentModel(
    localId: 1,
    classroomId: 1,
    firstName: 'vitor',
    lastName: 'cantinho',
  );

  final textModel =
      TextModel(body: "", title: "", tutorId: 1, studentId: 1, localId: 1);

  final tMistakeInputModel1 = MistakeModel(
    commentary: "",
    correctionId: 1,
    wordIndex: 1,
  );

  final tMistakeOutputModel1 = MistakeModel(
    commentary: "",
    correctionId: 1,
    wordIndex: 1,
    localId: 1,
  );

  final tCorrectionOutputModel1 = CorrectionModel(
    localId: 1,
    studentId: 1,
    textId: 1,
  );

  final tCorrectionInputModel1 = CorrectionModel(
    studentId: 1,
    textId: 1,
  );

  final textPk = 1;
  final studentPk = 1;

  setUp(() async {
    mockDatabase = MockDatabase();

    mistakeLocalDataSourceImpl = MistakeLocalDataSourceImpl(
      database: mockDatabase,
    );
  });

  group("cacheMistake", () {
    test("should correctly cache and return a valid mistake", () async {
      when(mockDatabase.insertMistake(tMistakeInputModel1))
          .thenAnswer((_) async => tValidPk);

      final result =
          await mistakeLocalDataSourceImpl.cacheNewMistake(tMistakeInputModel1);
      verify(mockDatabase.insertMistake(tMistakeInputModel1));
      expect(result, tMistakeOutputModel1);
    });

    test("should throw CacheException when trying to insert an invalid mistake",
        () {
      when(mockDatabase.insertMistake(tMistakeInputModel1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await mistakeLocalDataSourceImpl
              .cacheNewMistake(tMistakeInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteCorrectionFromCache", () {
    test("should correctly delete a correction and its mistakes", () async {
      when(mockDatabase.deleteMistakesOfCorrection(1))
          .thenAnswer((_) async => _);
      when(mockDatabase.deleteCorrection(1)).thenAnswer((_) async => _);

      await mistakeLocalDataSourceImpl
          .deleteCorrectionFromCache(tCorrectionOutputModel1);
      verifyInOrder([
        mockDatabase.deleteMistakesOfCorrection(1),
        mockDatabase.deleteCorrection(1)
      ]);
      verifyNoMoreInteractions(mockDatabase);
    });

    test("should throw CacheException when trying to delete an invalid mistake",
        () {
      when(mockDatabase.deleteMistakesOfCorrection(1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await mistakeLocalDataSourceImpl
              .deleteCorrectionFromCache(tCorrectionOutputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getMistake", () {
    test("should correctly return a list of mistakes", () async {
      when(mockDatabase.getMistakesOfCorrection(
        1,
      )).thenAnswer((_) async => [tMistakeOutputModel1]);

      final result = await mistakeLocalDataSourceImpl
          .getMistakesFromCache(tCorrectionOutputModel1);

      verify(mockDatabase.getMistakesOfCorrection(1));

      final testResult = listEquals(result, [tMistakeOutputModel1]);

      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getMistakesOfCorrection(1)).thenAnswer((_) async => []);

      final result = await mistakeLocalDataSourceImpl
          .getMistakesFromCache(tCorrectionOutputModel1);

      verify(mockDatabase.getMistakesOfCorrection(1));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getMistakesOfCorrection(1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await mistakeLocalDataSourceImpl
              .getMistakesFromCache(tCorrectionOutputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("cacheCorrection", () {
    test("should correctly cache and return a valid correction", () async {
      when(mockDatabase.insertCorrection(tCorrectionInputModel1))
          .thenAnswer((_) async => tValidPk);

      final result = await mistakeLocalDataSourceImpl
          .cacheNewCorrection(tCorrectionInputModel1);
      verify(mockDatabase.insertCorrection(tCorrectionInputModel1));
      expect(result, tCorrectionOutputModel1);
    });

    test("should throw CacheException when trying to insert an invalid mistake",
        () {
      when(mockDatabase.insertCorrection(tCorrectionInputModel1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await mistakeLocalDataSourceImpl
              .cacheNewCorrection(tCorrectionInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getCorrection", () {
    test("should correctly return a correction", () async {
      when(mockDatabase.getCorrection(textId: 1, studentId: 1))
          .thenAnswer((_) async => tCorrectionOutputModel1);

      final result = await mistakeLocalDataSourceImpl.getCorrectionFromCache(
          studentModel: studentModel, textModel: textModel);

      verify(mockDatabase.getCorrection(
        textId: 1,
        studentId: 1,
      ));

      expect(result, tCorrectionOutputModel1);
    });

    test("should throw a cacheException", () async {
      when(mockDatabase.getCorrection(textId: 1, studentId: 1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await mistakeLocalDataSourceImpl.getCorrectionFromCache(
                textModel: textModel,
                studentModel: studentModel,
              ),
          throwsA(TypeMatcher<CacheException>()));
    });

     test("should throw an EmptyDataException", () async {
      when(mockDatabase.getCorrection(textId: 1, studentId: 1))
          .thenThrow(EmptyDataException());

      expect(
          () async => await mistakeLocalDataSourceImpl.getCorrectionFromCache(
                textModel: textModel,
                studentModel: studentModel,
              ),
          throwsA(TypeMatcher<EmptyDataException>()));
    });
  });
}

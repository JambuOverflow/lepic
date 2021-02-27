import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';

import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';

import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

Future<void> main() {
  MockDatabase mockDatabase;
  MockUserLocalDataSource mockUserLocalDataSource;
  TextLocalDataSourceImpl textLocalDataSourceImpl;
  StudentModel tStudentModel;

  final tValidPk = 1;

  final tTextInputModel1 = TextModel(
    studentId: 1,
    title: '1',
    body: "A",
    localId: null,
    creationDate: DateTime(2020),
  );

  final tTextInputModel2 = TextModel(
    studentId: 1,
    title: '2',
    body: "B",
    localId: null,
    creationDate: DateTime(2020),
  );

  final tTextModel1 = TextModel(
    studentId: 1,
    title: '1',
    body: "A",
    localId: 1,
    creationDate: DateTime(2020),
  );

  final tTextCompanion1 = tTextInputModel1.toCompanion(true);

  final tTextModels = [tTextInputModel1, tTextInputModel2];

  setUp(() async {
    mockDatabase = MockDatabase();
    mockUserLocalDataSource = MockUserLocalDataSource();
    tStudentModel = StudentModel(
      localId: 1,
      firstName: 'a',
      lastName: 'b',
      classroomId: 1,
    );

    textLocalDataSourceImpl = TextLocalDataSourceImpl(
        database: mockDatabase, userLocalDataSource: mockUserLocalDataSource);

    when(mockUserLocalDataSource.getUserId()).thenAnswer((_) async => 1);
  });

  group("cacheText", () {
    test("should correctly cache and return a valid text", () async {
      when(mockDatabase.insertText(tTextCompanion1))
          .thenAnswer((_) async => tValidPk);

      final result =
          await textLocalDataSourceImpl.cacheNewText(tTextInputModel1);
      verify(mockDatabase.insertText(tTextCompanion1));
      expect(result, tTextModel1);
    });

    test("should throw CacheException when trying to insert an invalid text",
        () {
      when(mockDatabase.insertText(tTextCompanion1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async =>
              await textLocalDataSourceImpl.cacheNewText(tTextInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteText", () {
    test("should correctly delete a cached text", () async {
      when(mockDatabase.deleteText(tValidPk)).thenAnswer((_) async => 1);

      await textLocalDataSourceImpl.deleteTextFromCache(tTextModel1);
      verify(mockDatabase.deleteText(tValidPk));
    });

    test("should throw CacheException when trying to delete an ivalid text",
        () {
      when(mockDatabase.deleteText(tValidPk))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async =>
              await textLocalDataSourceImpl.deleteTextFromCache(tTextModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getTextOfClassroom", () {
    test("should correctly return a list of texts", () async {
      when(mockDatabase.getStudentTexts(tValidPk))
          .thenAnswer((_) async => tTextModels);

      final result =
          await textLocalDataSourceImpl.getStudentTextsFromCache(tStudentModel);

      verify(mockDatabase.getStudentTexts(tValidPk));
      final testResult = listEquals(result, tTextModels);
      expect(true, testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getStudentTexts(tValidPk)).thenAnswer((_) async => []);

      final result =
          await textLocalDataSourceImpl.getStudentTextsFromCache(tStudentModel);

      verify(mockDatabase.getStudentTexts(tValidPk));
      final testResult = listEquals(result, []);
      expect(true, testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getStudentTexts(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await textLocalDataSourceImpl
              .getStudentTextsFromCache(tStudentModel),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getText", () {
    test("should correctly return a list of texts", () async {
      when(mockDatabase.getAllTextsOfUser(1))
          .thenAnswer((_) async => tTextModels);

      final result = await textLocalDataSourceImpl.getAllUserTextsFromCache();

      verify(mockDatabase.getAllTextsOfUser(1));
      final testResult = listEquals(result, tTextModels);
      expect(true, testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getAllTextsOfUser(1)).thenAnswer((_) async => []);

      final result = await textLocalDataSourceImpl.getAllUserTextsFromCache();

      verify(mockDatabase.getAllTextsOfUser(1));
      final testResult = listEquals(result, []);
      expect(true, testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getAllTextsOfUser(1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await textLocalDataSourceImpl.getAllUserTextsFromCache(),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("updateText", () {
    test("should correctly update a cached text", () async {
      when(mockDatabase.updateText(tTextModel1)).thenAnswer((_) async => true);

      await textLocalDataSourceImpl.updateCachedText(tTextModel1);
      verify(mockDatabase.updateText(tTextModel1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.updateText(tTextModel1)).thenAnswer((_) async => false);

      expect(
          () async =>
              await textLocalDataSourceImpl.updateCachedText(tTextModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getText", () {
    test("should correctly get a cached text", () async {
      when(mockDatabase.getText(1)).thenAnswer((_) async => tTextModel1);

      final result = await textLocalDataSourceImpl.getTextFromCache(1);
      expect(result, tTextModel1);
      verify(mockDatabase.getText(1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.getText(1)).thenThrow(SqliteException(787, ""));

      expect(() async => await textLocalDataSourceImpl.getTextFromCache(1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });
}

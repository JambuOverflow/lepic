import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';

import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';

import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

Future<void> main() {
  MockDatabase mockDatabase;
  TextLocalDataSourceImpl textLocalDataSourceImpl;
  ClassroomModel tClassroomModel;

  final tValidPk = 1;

  final tClassroom = Classroom(
    grade: 1,
    name: "A",
    id: 1,
  );

  final tTextInputModel1 =
      TextModel(classId: 1, title: '1', body: "A", localId: null);
  final tTextInputModel2 =
      TextModel(classId: 1, title: '2', body: "B", localId: null);

  final tTextModel1 = TextModel(classId: 1, title: '1', body: "A", localId: 1);

  final tTextCompanion1 = tTextInputModel1.toCompanion(true);

  final tTextModels = [tTextInputModel1, tTextInputModel2];

  setUp(() async {
    mockDatabase = MockDatabase();
    tClassroomModel = ClassroomModel(grade:1, name:"A", localId: 1);

    textLocalDataSourceImpl = TextLocalDataSourceImpl(
      database: mockDatabase,
    );
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

  group("getText", () {
    test("should correctly return a list of texts", () async {
      when(mockDatabase.getTexts(tValidPk))
          .thenAnswer((_) async => tTextModels);

      final result =
          await textLocalDataSourceImpl.getTextsFromCache(tClassroomModel);

      verify(mockDatabase.getTexts(tValidPk));
      final testResult = listEquals(result, tTextModels);
      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getTexts(tValidPk)).thenAnswer((_) async => []);

      final result =
          await textLocalDataSourceImpl.getTextsFromCache(tClassroomModel);

      verify(mockDatabase.getTexts(tValidPk));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getTexts(tValidPk)).thenThrow(SqliteException(787, ""));

      expect(
          () async =>
              await textLocalDataSourceImpl.getTextsFromCache(tClassroomModel),
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
}

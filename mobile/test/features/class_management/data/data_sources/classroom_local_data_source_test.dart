import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

Future<void> main() {
  MockDatabase mockDatabase;
  MockUserLocalDataSource mockUserLocalDataSource;
  ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;

  final tValidPk = 1;

  final tClassroomInputModel1 =
      ClassroomModel(tutorId: 1, grade: 1, name: "A", localId: null);
  final tClassroomInputModel2 =
      ClassroomModel(tutorId: 1, grade: 1, name: "B", localId: null);

  final tClassroomModel1 = ClassroomModel(
    tutorId: 1,
    grade: 1,
    name: "A",
    localId: 1,
    deleted: false,
  );
  final tClassroomModel1Deleted = ClassroomModel(
    tutorId: 1,
    grade: 1,
    name: "A",
    localId: 1,
    deleted: true,
  );

  final tClassroomCompanion1 = tClassroomInputModel1.toCompanion(true);
  final tClassroomCompanionPk1 = tClassroomModel1.toCompanion(true);

  final tClassroomModels = [tClassroomInputModel1, tClassroomInputModel2];

  setUp(() async {
    mockUserLocalDataSource = MockUserLocalDataSource();
    mockDatabase = MockDatabase();

    classroomLocalDataSourceImpl = ClassroomLocalDataSourceImpl(
      database: mockDatabase,
      userLocalDataSource: mockUserLocalDataSource,
    );

    when(mockUserLocalDataSource.getUserId()).thenAnswer((_) async => 1);
  });

  group("cacheClassroom", () {
    test("should correctly cache and return a valid classroom", () async {
      when(mockDatabase.insertClassroom(tClassroomCompanion1))
          .thenAnswer((_) async => tValidPk);

      final result = await classroomLocalDataSourceImpl
          .cacheNewClassroom(tClassroomInputModel1);
      verify(mockDatabase.insertClassroom(tClassroomCompanion1));
      expect(result, tClassroomModel1);
    });

    test(
        "should throw CacheException when trying to insert an invalid classroom",
        () {
      when(mockDatabase.insertClassroom(tClassroomCompanion1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await classroomLocalDataSourceImpl
              .cacheNewClassroom(tClassroomInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteClassroom", () {
    test("should correctly delete a cached classroom", () async {
      when(mockDatabase.updateClassroom(tClassroomModel1Deleted))
          .thenAnswer((_) async => null);

      await classroomLocalDataSourceImpl
          .deleteClassroomFromCache(tClassroomModel1);
      verify(mockDatabase.updateClassroom(tClassroomModel1Deleted));
    });

    test(
        "should throw CacheException when trying to delete an ivalid classroom",
        () {
      when(mockDatabase.updateClassroom(tClassroomModel1Deleted))
          .thenThrow((SqliteException(787, "")));
      expect(
          () async => await classroomLocalDataSourceImpl
              .deleteClassroomFromCache(tClassroomModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getClassroom", () {
    test("should correctly return a list of classrooms", () async {
      when(mockDatabase.getClassrooms(tValidPk))
          .thenAnswer((_) async => tClassroomModels);

      final result =
          await classroomLocalDataSourceImpl.getClassroomsFromCache();

      verify(mockDatabase.getClassrooms(tValidPk));
      final testResult = listEquals(result, tClassroomModels);
      expect(true, testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getClassrooms(tValidPk)).thenAnswer((_) async => []);

      final result =
          await classroomLocalDataSourceImpl.getClassroomsFromCache();

      verify(mockDatabase.getClassrooms(tValidPk));
      final testResult = listEquals(result, []);
      expect(true, testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getClassrooms(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async =>
              await classroomLocalDataSourceImpl.getClassroomsFromCache(),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getClassroomFromId", () {
    test("should correctly return a classroom", () async {
      when(mockDatabase.getClassroom(tValidPk))
          .thenAnswer((_) async => tClassroomModel1);

      final result = await classroomLocalDataSourceImpl
          .getClassroomFromCacheWithId(tValidPk);

      verify(mockDatabase.getClassroom(tValidPk));
      expect(result, tClassroomModel1);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getClassroom(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async =>
              await classroomLocalDataSourceImpl.getClassroomFromCacheWithId(1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("updateClassroom", () {
    test("should correctly update a cached classroom", () async {
      when(mockDatabase.updateClassroom(tClassroomModel1))
          .thenAnswer((_) async => null);

      await classroomLocalDataSourceImpl
          .updateCachedClassroom(tClassroomModel1);
      verify(mockDatabase.updateClassroom(tClassroomModel1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.updateClassroom(tClassroomModel1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await classroomLocalDataSourceImpl
              .updateCachedClassroom(tClassroomModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("cacheClassroom", () {
    test("should correctly update a cached classroom", () async {
      when(mockDatabase.updateClassroom(tClassroomModel1))
          .thenAnswer((_) async => true);
      when(mockDatabase.classroomExists(tClassroomModel1.localId))
          .thenAnswer((_) async => true);

      await classroomLocalDataSourceImpl.cacheClassroom(tClassroomModel1);
      verify(mockDatabase.updateClassroom(tClassroomModel1));
    });

    test(
        "should correctly cache and return a valid classroom when it does not have a localId",
        () async {
      when(mockDatabase.insertClassroom(tClassroomCompanion1))
          .thenAnswer((_) async => tValidPk);
      when(mockDatabase.classroomExists(tClassroomModel1.localId))
          .thenAnswer((_) async => false);

      await classroomLocalDataSourceImpl.cacheClassroom(tClassroomInputModel1);
      verify(mockDatabase.insertClassroom(tClassroomCompanion1));
    });

    test(
        "should correctly cache and return a valid classroom when it has an existing pk",
        () async {
      when(mockDatabase.insertClassroom(tClassroomCompanionPk1))
          .thenAnswer((_) async => tValidPk);
      when(mockDatabase.classroomExists(tClassroomModel1.localId))
          .thenAnswer((_) async => false);

      await classroomLocalDataSourceImpl.cacheClassroom(tClassroomModel1);
      verify(mockDatabase.insertClassroom(tClassroomCompanionPk1));
    });
  });
}

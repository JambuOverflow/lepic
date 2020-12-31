import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

Future<void> main() {
  MockDatabase mockDatabase;
  ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;

  final tValidPk = 1;

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
    id: 1,
  );

  final tUserModel = userEntityToModel(tUser);

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
    mockDatabase = MockDatabase();

    classroomLocalDataSourceImpl = ClassroomLocalDataSourceImpl(
      database: mockDatabase,
    );
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
          await classroomLocalDataSourceImpl.getClassroomsFromCache(tUserModel);

      verify(mockDatabase.getClassrooms(tValidPk));
      final testResult = listEquals(result, tClassroomModels);
      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getClassrooms(tValidPk)).thenAnswer((_) async => []);

      final result =
          await classroomLocalDataSourceImpl.getClassroomsFromCache(tUserModel);

      verify(mockDatabase.getClassrooms(tValidPk));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getClassrooms(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await classroomLocalDataSourceImpl
              .getClassroomsFromCache(tUserModel),
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

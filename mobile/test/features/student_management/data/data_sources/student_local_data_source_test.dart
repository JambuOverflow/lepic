import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockDatabase mockDatabase;
  StudentLocalDataSourceImpl studentLocalDataSourceImpl;

  final tClassroomModel = ClassroomModel(
    localId: 1,
    grade: 7,
    name: 'Science Class',
    lastUpdated: null,
    clientLastUpdated: null,
    deleted: null,
    tutorId: 1,
  );

  final tValidPk = 1;

  final tStudentInputModel1 = StudentModel(
    localId: null,
    classroomId: 1,
    firstName: 'vitor',
    lastName: 'cantinho',
  );

  final tStudentInputModel2 = StudentModel(
    localId: null,
    classroomId: 1,
    firstName: 'rena',
    lastName: 'pupunha',
  );

  final tStudentModel1 = StudentModel(
    localId: 1,
    classroomId: 1,
    firstName: 'vitor',
    lastName: 'cantinho',
  );

  final tStudentCompanion1 = tStudentInputModel1.toCompanion(true);

  final tStudentModels = [tStudentInputModel1, tStudentInputModel2];

  setUp(() async {
    mockDatabase = MockDatabase();

    studentLocalDataSourceImpl = StudentLocalDataSourceImpl(
      database: mockDatabase,
    );
  });

  group("cacheStudent", () {
    test("should correctly cache and return a valid student", () async {
      when(mockDatabase.insertStudent(tStudentCompanion1))
          .thenAnswer((_) async => tValidPk);

      final result =
          await studentLocalDataSourceImpl.cacheNewStudent(tStudentInputModel1);
      verify(mockDatabase.insertStudent(tStudentCompanion1));
      expect(result, tStudentModel1);
    });

    test("should throw CacheException when trying to insert an invalid student",
        () {
      when(mockDatabase.insertStudent(tStudentCompanion1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await studentLocalDataSourceImpl
              .cacheNewStudent(tStudentInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteStudent", () {
    test("should correctly delete a cached student", () async {
      when(mockDatabase.deleteStudent(tValidPk)).thenAnswer((_) async => 1);

      await studentLocalDataSourceImpl.deleteStudentFromCache(tStudentModel1);
      verify(mockDatabase.deleteStudent(tValidPk));
    });

    test("should throw CacheException when trying to delete an invalid student",
        () {
      when(mockDatabase.deleteStudent(tValidPk)).thenAnswer((_) async => 0);
      expect(
          () async => await studentLocalDataSourceImpl
              .deleteStudentFromCache(tStudentModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getStudent", () {
    test("should correctly return a list of students", () async {
      when(mockDatabase.getStudents(tValidPk))
          .thenAnswer((_) async => tStudentModels);

      final result = await studentLocalDataSourceImpl
          .getStudentsFromCache(tClassroomModel);

      verify(mockDatabase.getStudents(tValidPk));
      final testResult = listEquals(result, tStudentModels);
      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getClassrooms(tValidPk)).thenAnswer((_) async => []);

      final result = await studentLocalDataSourceImpl
          .getStudentsFromCache(tClassroomModel);

      verify(mockDatabase.getStudents(tValidPk));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getStudents(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await studentLocalDataSourceImpl
              .getStudentsFromCache(tClassroomModel),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getStudentFromId", () {
    test("should correctly return a student", () async {
      when(mockDatabase.getStudent(tValidPk))
          .thenAnswer((_) async => tStudentModel1);

      final result =
          await studentLocalDataSourceImpl.getStudentFromCacheWithId(tValidPk);

      verify(mockDatabase.getStudent(tValidPk));
      expect(result, tStudentModel1);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getStudent(tValidPk))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await studentLocalDataSourceImpl
              .getStudentFromCacheWithId(tValidPk),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("updateStudent", () {
    test("should correctly update a cached student", () async {
      when(mockDatabase.updateStudent(tStudentModel1))
          .thenAnswer((_) async => true);

      await studentLocalDataSourceImpl.updateCachedStudent(tStudentModel1);
      verify(mockDatabase.updateStudent(tStudentModel1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.updateStudent(tStudentModel1))
          .thenAnswer((_) async => false);

      expect(
          () async => await studentLocalDataSourceImpl
              .updateCachedStudent(tStudentModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/student_management/data/repositories/student_repository_impl.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mockito/mockito.dart';

class MockStudentLocalDataSource extends Mock
    implements StudentLocalDataSource {}

class MockClassroomEntityModelConverter extends Mock
    implements ClassroomEntityModelConverter {}

void main() {
  MockStudentLocalDataSource mockLocalDataSource;
  StudentRepositoryImpl repository;
  MockClassroomEntityModelConverter mockClassroomEntityModelConverter;
  ClassroomModel tClassroomModel;

  final tClassroom = Classroom(
    grade: 1,
    name: "A",
    id: 1,
  );

  final tStudent = Student(
    id: 1,
    classroomId: null,
    firstName: 'felipe',
    lastName: 'pau',
  );

  final tStudentModel = studentEntityToModel(tStudent);

  final tStudentModels = [tStudentModel, tStudentModel];
  final tStudents = [tStudent, tStudent];

  setUp(() async {
    mockClassroomEntityModelConverter = MockClassroomEntityModelConverter();
    tClassroomModel = ClassroomModel(localId: 1, grade: 1, name: "A");
    mockLocalDataSource = MockStudentLocalDataSource();

    repository = StudentRepositoryImpl(
      localDataSource: mockLocalDataSource,
      classroomEntityModelConverter: mockClassroomEntityModelConverter,
    );
    when(mockClassroomEntityModelConverter.classroomEntityToModel(tClassroom))
        .thenAnswer((_) async => tClassroomModel);
  });

  group('createStudent', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewStudent(tStudentModel))
          .thenThrow(CacheException());

      final result = await repository.createStudent(tStudent);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created student', () async {
      when(mockLocalDataSource.cacheNewStudent(tStudentModel))
          .thenAnswer((_) async => tStudentModel);

      final result = await repository.createStudent(tStudent);

      verify(mockLocalDataSource.cacheNewStudent(tStudentModel));
      expect(result, Right(tStudent));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('deleteStudent', () {
    test('should delete a student', () async {
      when(mockLocalDataSource.deleteStudentFromCache(tStudentModel))
          .thenAnswer((_) async => Right(null));

      final expected = await repository.deleteStudent(tStudent);

      expect(expected, Right(null));

      verify(mockLocalDataSource.deleteStudentFromCache(tStudentModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteStudentFromCache(tStudentModel))
          .thenThrow(CacheException());

      final result = await repository.deleteStudent(tStudent);
      verify(mockLocalDataSource.deleteStudentFromCache(tStudentModel));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('updateStudent', () {
    test('should return a classroom when updateStudent is called', () async {
      when(mockLocalDataSource.updateCachedStudent(tStudentModel))
          .thenAnswer((_) async => tStudentModel);

      final result = await repository.updateStudent(tStudent);

      verify(mockLocalDataSource.updateCachedStudent(tStudentModel));
      expect(result, Right(tStudent));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedStudent(tStudentModel))
          .thenThrow(CacheException());

      final result = await repository.updateStudent(tStudent);

      verify(mockLocalDataSource.updateCachedStudent(tStudentModel));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getStudents', () {
    test('should return a list of students when getStudents is called',
        () async {
      when(mockLocalDataSource.getStudentsFromCache(tClassroomModel))
          .thenAnswer((_) async => tStudentModels);

      final result = await repository.getStudents(tClassroom);
      final List<Student> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tStudents);
      expect(true, resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getStudentsFromCache(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.getStudents(tClassroom);

      expect(result, Left(CacheFailure()));
    });
  });

  group('getStudentFromId', () {
    test('should return a lstudent', () async {
      when(mockLocalDataSource.getStudentFromCacheWithId(1))
          .thenAnswer((_) async => tStudentModel);

      final result = await repository.getStudentFromId(1);

      expect(result, Right(tStudent));
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getStudentFromCacheWithId(1))
          .thenThrow(CacheException());

      final result = await repository.getStudentFromId(1);

      expect(result, Left(CacheFailure()));
    });
  });
}

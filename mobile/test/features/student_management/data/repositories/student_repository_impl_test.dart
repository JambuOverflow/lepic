import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/student_management/data/repositories/student_repository_impl.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockStudentLocalDataSource extends Mock
    implements StudentLocalDataSource {}

void main() {
  MockStudentLocalDataSource mockLocalDataSource;
  StudentRepositoryImpl repository;

  final tClassroom = Classroom(
    tutorId: 1,
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
  final tClassroomModel = classroomEntityToModel(tClassroom);

  final tStudentModels = [tStudentModel, tStudentModel];
  final tStudents = [tStudent, tStudent];

  setUp(() {
    mockLocalDataSource = MockStudentLocalDataSource();

    repository = StudentRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
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
          .thenAnswer((_) async => _);

      await repository.deleteStudent(tStudent);

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
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getStudentsFromCache(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.getStudents(tClassroom);

      expect(result, Left(CacheFailure()));
    });
  });
}

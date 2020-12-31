import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';

import '../data_sources/student_local_data_source.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;
  final ClassroomEntityModelConverter classroomEntityModelConverter;

  StudentRepositoryImpl({
    @required this.localDataSource,
    @required this.classroomEntityModelConverter,
  });

  @override
  Future<Either<Failure, Student>> createStudent(Student student) async {
    return await _tryCacheStudent(student);
  }

  Future<Either<Failure, Student>> _tryCacheStudent(Student student) async {
    try {
      var model = studentEntityToModel(student);
      var localModel = await localDataSource.cacheNewStudent(model);
      var localStudent = studentModelToEntity(localModel);
      return Right(localStudent);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(Student student) async {
    return await _tryDeleteStudent(student);
  }

  Future<Either<Failure, void>> _tryDeleteStudent(Student student) async {
    try {
      var model = studentEntityToModel(student);
      await localDataSource.deleteStudentFromCache(model);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Student>>> getStudents(
      Classroom classroom) async {
    return await _tryGetStudents(classroom);
  }

  Future<Either<Failure, List<Student>>> _tryGetStudents(
      Classroom classroom) async {
    try {
      var classroomModel = await classroomEntityModelConverter.classroomEntityToModel(classroom);
      var listStudentModel =
          await localDataSource.getStudentsFromCache(classroomModel);
      var listStudentEntity = [
        for (var model in listStudentModel) studentModelToEntity(model)
      ];
      return Right(listStudentEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Student>> updateStudent(Student student) async {
    return await _tryUpdateStudent(student);
  }

  Future<Either<Failure, Student>> _tryUpdateStudent(Student student) async {
    try {
      var model = studentEntityToModel(student);
      var localModel = await localDataSource.updateCachedStudent(model);
      var localStudent = studentModelToEntity(localModel);
      return Right(localStudent);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

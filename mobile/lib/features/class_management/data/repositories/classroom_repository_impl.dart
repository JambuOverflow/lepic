import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';


import '../data_sources/classroom_local_data_source.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomLocalDataSource localDataSource;

  ClassroomRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, Classroom>> createClassroom(
      Classroom classroom) async {
    return await _tryCacheClassroom(classroom);
  }

  @override
  Future<Either<Failure, void>> deleteClassroom(Classroom classroom) async {
    return await _tryDeleteClassroom(classroom);
  }

  Future<Either<Failure, void>> _tryDeleteClassroom(Classroom classroom) async {
    try {
      var model = classroomEntityToModel(classroom);
      await localDataSource.deleteClassroomFromCache(model);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, Classroom>> _tryCacheClassroom(
      Classroom classroom) async {
    try {
      var model = classroomEntityToModel(classroom);
      var localModel = await localDataSource.cacheNewClassroom(model);
      var localClassroom = classroomModelToEntity(localModel);
      return Right(localClassroom);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Classroom>>> getClassrooms(User user) async {
    return await _tryGetClassrooms(user);
  }

  Future<Either<Failure, List<Classroom>>> _tryGetClassrooms(User user) async {
    try {
      var userModel = userEntityToModel(user);
      var listClassroomModel =
          await localDataSource.getClassroomsFromCache(userModel);
      var listClassroomEntity = [
        for (var model in listClassroomModel) classroomModelToEntity(model)
      ];
      return Right(listClassroomEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Classroom>> updateClassroom(
      Classroom classroom) async {
    return await _tryUpdateClassroom(classroom);
  }

  Future<Either<Failure, Classroom>> _tryUpdateClassroom(
      Classroom classroom) async {
    try {
      var model = classroomEntityToModel(classroom);
      var localModel = await localDataSource.updateCachedClassroom(model);
      var localClassroom = classroomModelToEntity(localModel);
      return Right(localClassroom);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

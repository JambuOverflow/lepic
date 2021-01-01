import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:clock/clock.dart';
import '../data_sources/classroom_local_data_source.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomLocalDataSource localDataSource;
  final ClassroomRemoteDataSource remoteDataSource;
  final Clock clock;

  ClassroomRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.clock,
  });

  Classroom updateClientLastUpdated(Classroom classroom) {
    DateTime time = clock.now();

    DateTime lastUpdated = time.toUtc();
    return Classroom(
      grade: classroom.grade,
      name: classroom.name,
      tutorId: classroom.tutorId,
      id: classroom.id,
      lastUpdated: classroom.lastUpdated,
      clientLastUpdated: lastUpdated,
      deleted: classroom.deleted,
      schoolId: classroom.schoolId,
    );
  }

  @override
  Future<Either<Failure, Classroom>> createClassroom(
      Classroom classroom) async {
    classroom = updateClientLastUpdated(classroom);
    return await _tryCacheClassroom(classroom);
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
  Future<Either<Failure, void>> deleteClassroom(Classroom classroom) async {
    classroom = updateClientLastUpdated(classroom);
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
    classroom = updateClientLastUpdated(classroom);
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

  @override
  Future<Either<Failure, void>> syncClassrooms() async {
    final Response response = await remoteDataSource.synchronize();
    if (response is UnsuccessfulResponse) {
      final UnsuccessfulResponse unsuccessfulResponse =
          (response as UnsuccessfulResponse);
      return Left(ServerFailure(message: unsuccessfulResponse.message));
    } 
  }
}

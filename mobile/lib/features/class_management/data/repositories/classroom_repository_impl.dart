import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:http/http.dart' as http;

import '../data_sources/classroom_local_data_source.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ClassroomRemoteDataSource remoteDataSource;

  ClassroomRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Classroom>> createClassroom(
      Classroom classroom) async {
    if (await networkInfo.isConnected) {
      return await _trySendClassroomAndCacheIt(classroom);
    } else {
      return await _tryCacheClassroom(classroom);
    }
  }

  @override
  Future<Either<Failure, http.Response>> deleteClassroom(
      Classroom classroom) async {
    if (await networkInfo.isConnected) {
      return await _tryDeleteRemoteClassroom(classroom);
    }
  }

  Future<Either<Failure, Classroom>> _trySendClassroomAndCacheIt(
      Classroom classroom) async {
    try {
      final remoteClassroom =
          await remoteDataSource.sendNewClassroom(classroom);
      try {
        await localDataSource.cacheClassroom(classroom);
        return Right(remoteClassroom);
      } on CacheException {
        return Left(CacheFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, Classroom>> _tryCacheClassroom(
      Classroom classroom) async {
    try {
      var localClassroom = await localDataSource.cacheClassroom(classroom);
      return Right(localClassroom);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, http.Response>> _tryDeleteRemoteClassroom(
      Classroom classroom) async {
    try {
      await localDataSource.deleteClassroomFromCache(classroom);
      final response = await remoteDataSource.deleteClassroom(classroom);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Classroom>>> getClassrooms(User user) {
    // TODO: implement getClassrooms
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Classroom>> updateClassroom(Classroom classroom) {
    // TODO: implement updateClassroom
    throw UnimplementedError();
  }
}

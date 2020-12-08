import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:http/http.dart' as http;

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
  Future<Either<Failure, http.Response>> deleteClassroom(
      Classroom classroom) async {
    try {
      await localDataSource.deleteClassroomFromCache(classroom);
    } on CacheException {
      return Left(CacheFailure());
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

  @override
  Future<Either<Failure, List<Classroom>>> getClassrooms(User user) async {
    try {
      await localDataSource.getClassrooms(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Classroom>> updateClassroom(Classroom classroom) async {
    return await _tryCacheClassroom(classroom);
  }
}

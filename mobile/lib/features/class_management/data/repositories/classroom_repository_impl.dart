import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/database.dart';
import '../../../../core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:clock/clock.dart';
import '../data_sources/classroom_local_data_source.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomEntityModelConverter clasrooomEntityModelConverter;
  final ClassroomLocalDataSource localDataSource;
  final Clock clock;

  ClassroomRepositoryImpl({
    @required this.localDataSource,
    @required this.clock,
    @required this.clasrooomEntityModelConverter,
  });

  Classroom updateClientLastUpdated(Classroom classroom) {
    DateTime time = clock.now();

    DateTime lastUpdated = time.toUtc();
    return Classroom(
      grade: classroom.grade,
      name: classroom.name,
      id: classroom.id,
      lastUpdated: classroom.lastUpdated,
      clientLastUpdated: lastUpdated,
      deleted: classroom.deleted,
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
      final model =
          await clasrooomEntityModelConverter.classroomEntityToModel(classroom);
      final localModel = await localDataSource.cacheNewClassroom(model);
      final localClassroom =
          clasrooomEntityModelConverter.classroomModelToEntity(localModel);
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
      var model =
          await clasrooomEntityModelConverter.classroomEntityToModel(classroom);
      return Right(await localDataSource.deleteClassroomFromCache(model));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Classroom>>> getClassrooms() async {
    return await _tryGetClassrooms();
  }

  Future<Either<Failure, List<Classroom>>> _tryGetClassrooms() async {
    try {
      var listClassroomModel = await localDataSource.getClassroomsFromCache();
      var listClassroomEntity = [
        for (var model in listClassroomModel)
          clasrooomEntityModelConverter.classroomModelToEntity(model)
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
      var model =
          await clasrooomEntityModelConverter.classroomEntityToModel(classroom);
      var localModel = await localDataSource.updateCachedClassroom(model);
      var localClassroom =
          clasrooomEntityModelConverter.classroomModelToEntity(localModel);
      return Right(localClassroom);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Classroom>> getClassroomFromId(int id) async {
    try {
      final ClassroomModel classroomModel =
          await localDataSource.getClassroomFromCacheWithId(1);
      final Classroom classroom =
          clasrooomEntityModelConverter.classroomModelToEntity(classroomModel);
      return Right(classroom);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

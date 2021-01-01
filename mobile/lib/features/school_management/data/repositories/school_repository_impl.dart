import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/entity_model_converters/school_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/school_management/data/models/school_model.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

import '../data_sources/school_local_data_source.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolLocalDataSource localDataSource;
  final SchoolEntityModelConverter schoolEntityModelConverter;

  SchoolRepositoryImpl({
    @required this.localDataSource,
    @required this.schoolEntityModelConverter
  });

  @override
  Future<Either<Failure, School>> createSchool(School school) async {
    return await _tryCacheSchool(school);
  }

  Future<Either<Failure, School>> _tryCacheSchool(School school) async {
    try {
      var model = await schoolEntityModelConverter.schoolEntityToModel(school);
      var localModel = await localDataSource.cacheNewSchool(model);
      var localSchool = schoolEntityModelConverter.schoolModelToEntity(localModel);
      return Right(localSchool);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchool(School school) async {
    return await _tryDeleteSchool(school);
  }

  Future<Either<Failure, void>> _tryDeleteSchool(School school) async {
    try {
      var model = await schoolEntityModelConverter.schoolEntityToModel(school);
      await localDataSource.deleteSchoolFromCache(model);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<School>>> getSchools(User user) async {
    return await _tryGetSchools(user);
  }

  Future<Either<Failure, List<School>>> _tryGetSchools(User user) async {
    try {
      var userModel = userEntityToModel(user);
      var listSchoolModel =
          await localDataSource.getSchoolsFromCache(userModel);
      var listSchoolEntity = [
        for (var model in listSchoolModel) schoolEntityModelConverter.schoolModelToEntity(model)
      ];
      return Right(listSchoolEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, School>> updateSchool(School school) async {
    return await _tryUpdateSchool(school);
  }

  Future<Either<Failure, School>> _tryUpdateSchool(School school) async {
    try {
      var model = await schoolEntityModelConverter.schoolEntityToModel(school);
      var localModel = await localDataSource.updateCachedSchool(model);
      var localSchool = schoolEntityModelConverter.schoolModelToEntity(localModel);
      return Right(localSchool);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

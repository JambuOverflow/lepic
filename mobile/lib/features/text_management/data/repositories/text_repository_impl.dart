import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/data/models/text_model.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

import '../data_sources/text_local_data_source.dart';

class TextRepositoryImpl implements TextRepository {
  final TextLocalDataSource localDataSource;
  final ClassroomEntityModelConverter classroomEntityModelConverter;
  final TextEntityModelConverter textEntityModelConverter;

  TextRepositoryImpl({
    @required this.localDataSource,
    @required this.classroomEntityModelConverter,
    @required this.textEntityModelConverter,
  });

  @override
  Future<Either<Failure, MyText>> createText(MyText text) async {
    return await _tryCacheText(text);
  }

  @override
  Future<Either<Failure, void>> deleteText(MyText text) async {
    return await _tryDeleteText(text);
  }

  @override
  Future<Either<Failure, List<MyText>>> getTextsOfClassroom(
      Classroom classroom) async {
    return await _tryGetTextsOfClassroom(classroom);
  }

  @override
  Future<Either<Failure, MyText>> updateText(MyText text) async {
    return await _tryUpdateText(text);
  }

  Future<Either<Failure, MyText>> _tryUpdateText(MyText text) async {
    try {
      var model = await textEntityModelConverter.mytextEntityToModel(text);
      var localModel = await localDataSource.updateCachedText(model);
      var localText = textEntityModelConverter.mytextModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, void>> _tryDeleteText(MyText text) async {
    try {
      var model = await textEntityModelConverter.mytextEntityToModel(text);
      await localDataSource.deleteTextFromCache(model);
      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, MyText>> _tryCacheText(MyText text) async {
    try {
      var model = await textEntityModelConverter.mytextEntityToModel(text);
      var localModel = await localDataSource.cacheNewText(model);
      var localText = textEntityModelConverter.mytextModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<MyText>>> _tryGetTextsOfClassroom(
      Classroom classroom) async {
    try {
      var classroomModel =
          await classroomEntityModelConverter.classroomEntityToModel(classroom);
      var listTextModel =
          await localDataSource.getTextsFromCacheOfClassroom(classroomModel);
      var listTextEntity = [
        for (var model in listTextModel) textEntityModelConverter.mytextModelToEntity(model)
      ];
      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyText>>> getAllTextsOfUser() async {
    try {
      var listTextModel = await localDataSource.getAllUserTextsFromCache();
      var listTextEntity = [
        for (var model in listTextModel) textEntityModelConverter.mytextModelToEntity(model)
      ];
      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

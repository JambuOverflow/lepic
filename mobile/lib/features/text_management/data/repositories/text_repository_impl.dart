import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
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

  TextRepositoryImpl({
    @required this.localDataSource,
    @required this.classroomEntityModelConverter,
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
  Future<Either<Failure, List<MyText>>> getTextsOfClassroom(Classroom classroom) async {
    return await _tryGetTexts(classroom);
  }

  @override
  Future<Either<Failure, MyText>> updateText(MyText text) async {
    return await _tryUpdateText(text);
  }

  Future<Either<Failure, MyText>> _tryUpdateText(MyText text) async {
    try {
      var model = textEntityToModel(text);
      var localModel = await localDataSource.updateCachedText(model);
      var localText = textModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, void>> _tryDeleteText(MyText text) async {
    try {
      var model = textEntityToModel(text);
      await localDataSource.deleteTextFromCache(model);
      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, MyText>> _tryCacheText(MyText text) async {
    try {
      var model = textEntityToModel(text);
      var localModel = await localDataSource.cacheNewText(model);
      var localText = textModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<MyText>>> _tryGetTexts(
      Classroom classroom) async {
    try {
      var classroomModel =
          await classroomEntityModelConverter.classroomEntityToModel(classroom);
      var listTextModel =
          await localDataSource.getTextsFromCache(classroomModel);
      var listTextEntity = [
        for (var model in listTextModel) textModelToEntity(model)
      ];
      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/data/models/text_model.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

import '../data_sources/text_local_data_source.dart';

class TextRepositoryImpl implements TextRepository {
  final TextLocalDataSource localDataSource;

  TextRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, Text>> createText(Text text) async {
    return await _tryCacheText(text);
  }

  @override
  Future<Either<Failure, void>> deleteText(Text text) async {
    return await _tryDeleteText(text);
  }

  Future<Either<Failure, void>> _tryDeleteText(Text text) async {
    try {
      var model = textEntityToModel(text);
      await localDataSource.deleteTextFromCache(model);
      return null;
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, Text>> _tryCacheText(Text text) async {
    try {
      var model = textEntityToModel(text);
      var localModel = await localDataSource.cacheNewText(model);
      var localText = textModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Text>>> getTexts(Classroom classroom) async {
    return await _tryGetTexts(classroom);
  }

  Future<Either<Failure, List<Text>>> _tryGetTexts(Classroom classroom) async {
    try {
      var classroomModel = classroomEntityToModel(classroom);
      var listTextModel = await localDataSource.getTextsFromCache(classroomModel);
      var listTextEntity = [
        for (var model in listTextModel) textModelToEntity(model)
      ];
      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Text>> updateText(Text text) async {
    return await _tryUpdateText(text);
  }

  Future<Either<Failure, Text>> _tryUpdateText(Text text) async {
    try {
      var model = textEntityToModel(text);
      var localModel = await localDataSource.updateCachedText(model);
      var localText = textModelToEntity(localModel);
      return Right(localText);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

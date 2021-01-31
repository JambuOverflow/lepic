import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../student_management/domain/entities/student.dart';
import '../../../../core/data/entity_model_converters/student_entity_model_converter.dart';
import '../../../../core/data/entity_model_converters/text_entity_model_converter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/text_repository.dart';
import '../../domain/entities/text.dart';
import '../data_sources/text_local_data_source.dart';

class TextRepositoryImpl implements TextRepository {
  final TextLocalDataSource localDataSource;
  final StudentEntityModelConverter studentEntityModelConverter;
  final TextEntityModelConverter textEntityModelConverter;

  TextRepositoryImpl({
    @required this.localDataSource,
    @required this.studentEntityModelConverter,
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
  Future<Either<Failure, List<MyText>>> getStudentTexts(Student student) async {
    return await _tryGetStudentTexts(student);
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

  Future<Either<Failure, List<MyText>>> _tryGetStudentTexts(
      Student student) async {
    try {
      var studentModel =
          await studentEntityModelConverter.classroomEntityToModel(student);

      var listTextModel =
          await localDataSource.getStudentTextsFromCache(studentModel);

      var listTextEntity = [
        for (var model in listTextModel)
          textEntityModelConverter.mytextModelToEntity(model)
      ];

      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyText>>> getAllUserTexts() async {
    try {
      var listTextModel = await localDataSource.getAllUserTextsFromCache();
      var listTextEntity = [
        for (var model in listTextModel)
          textEntityModelConverter.mytextModelToEntity(model)
      ];
      return Right(listTextEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

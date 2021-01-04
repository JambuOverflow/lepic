import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

import '../data_sources/mistake_local_data_source.dart';

class CorrectionRepositoryImpl implements CorrectionRepository {
  final MistakeLocalDataSource localDataSource;
  final MistakeEntityModelConverter mistakeEntityModelConverter;
  final TextEntityModelConverter textEntityModelConverter;

  CorrectionRepositoryImpl({
    @required this.localDataSource,
    @required this.mistakeEntityModelConverter,
    @required this.textEntityModelConverter,
  });

  @override
  Future<Either<Failure, Correction>> createCorrection(
      Correction correction) async {
    try {
      List<MistakeModel> inputModels =
          mistakeEntityModelConverter.entityToModel(correction);
      List<MistakeModel> outputModels = [];

      for (var model in inputModels) {
        MistakeModel localModel = await localDataSource.cacheNewMistake(model);
        outputModels.add(localModel);
      }

      var localCorrection =
          mistakeEntityModelConverter.modelToEntity(outputModels);
      return Right(localCorrection);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCorrection(Correction correction) async {
    try {
      MistakeModel firstModel =
          mistakeEntityModelConverter.entityToModel(correction)[0];

      await localDataSource.deleteCorrectionMistakesFromCache(firstModel);

      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Correction>> getCorrection(
      {MyText text, Student student}) async {
    try {
      final StudentModel studentModel = studentEntityToModel(student);
      final TextModel textModel =
          await this.textEntityModelConverter.mytextEntityToModel(text);

      final List<MistakeModel> mistakes = await localDataSource
          .getCorrectionMistakesFromCache(studentModel: studentModel, textModel: textModel);

      final Correction correction =
          this.mistakeEntityModelConverter.modelToEntity(mistakes);
      return Right(correction);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Correction>> updateCorrection(
      Correction correction) async {
    Either<Failure, void> response = await deleteCorrection(correction);

    if (response.isLeft()) {
      return Left(CacheFailure());
    }

    Either<Failure, Correction> output = await createCorrection(correction);

    return output.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/correction_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/student_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

import '../data_sources/mistake_local_data_source.dart';

class CorrectionRepositoryImpl implements CorrectionRepository {
  final MistakeLocalDataSource localDataSource;
  final MistakeEntityModelConverter mistakeEntityModelConverter;
  final CorrectionEntityModelConverter correctionEntityModelConverter;
  final TextEntityModelConverter textEntityModelConverter;
  final StudentEntityModelConverter studentEntityModelConverter;

  CorrectionRepositoryImpl({
    @required this.localDataSource,
    @required this.mistakeEntityModelConverter,
    @required this.correctionEntityModelConverter,
    @required this.textEntityModelConverter,
    @required this.studentEntityModelConverter,
  });

  @override
  Future<Either<Failure, Correction>> createCorrection(
      Correction correction) async {
    try {
      Correction outputCorrection = await _createCorrection(correction, []);
      List<Mistake> outputMistakes = await _createMistakes(
        mistakes: correction.mistakes,
        correctionId: outputCorrection.localId,
      );
      final Correction result = Correction(
          localId: outputCorrection.localId,
          textId: outputCorrection.textId,
          studentId: outputCorrection.studentId,
          mistakes: outputMistakes);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Correction> _createCorrection(
      Correction correction, List<Mistake> outputMistakes) async {
    CorrectionModel correctionModel =
        correctionEntityModelConverter.entityToModel(correction);
    correctionModel = await localDataSource.cacheNewCorrection(correctionModel);
    final Correction result = correctionEntityModelConverter.modelToEntity(
      model: correctionModel,
      mistakes: outputMistakes,
    );
    return result;
  }

  Future<List<Mistake>> _createMistakes(
      {List<Mistake> mistakes, int correctionId}) async {
    List<Mistake> outputMistakes = [];

    for (var mistake in mistakes) {
      Mistake localMistake =
          await _createMistake(mistake: mistake, correctionId: correctionId);
      outputMistakes.add(localMistake);
    }
    return outputMistakes;
  }

  Future<Mistake> _createMistake({Mistake mistake, int correctionId}) async {
    MistakeModel inputModel = mistakeEntityModelConverter.entityToModel(
      entity: mistake,
      correctionId: correctionId,
    );
    MistakeModel localModel = await localDataSource.cacheNewMistake(inputModel);
    Mistake localMistake =
        mistakeEntityModelConverter.modelToEntity(localModel);
    return localMistake;
  }

  @override
  Future<Either<Failure, void>> deleteCorrection(Correction correction) async {
    try {
      CorrectionModel model =
          correctionEntityModelConverter.entityToModel(correction);

      await localDataSource.deleteCorrectionFromCache(model);

      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Correction>> getCorrection(
      {MyText text, Student student}) async {
    try {
      final StudentModel studentModel =
          await studentEntityModelConverter.entityToModel(student);
      final TextModel textModel =
          await textEntityModelConverter.mytextEntityToModel(text);

      final CorrectionModel correctionModel =
          await localDataSource.getCorrectionFromCache(
        studentModel: studentModel,
        textModel: textModel,
      );

      final List<MistakeModel> mistakeModels =
          await localDataSource.getMistakesFromCache(correctionModel);
      final List<Mistake> mistakes =
          mistakeEntityModelConverter.modelsToEntityList(mistakeModels);

      final Correction correction =
          correctionEntityModelConverter.modelToEntity(
        model: correctionModel,
        mistakes: mistakes,
      );
      return Right(correction);
    } on CacheException {
      return Left(CacheFailure());
    } on EmptyDataException {
      return Left(EmptyDataFailure());
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

  @override
  Future<Either<Failure, Correction>> getCorrectionFromId(
      {int textId, int studentId}) async {
    try {
      final CorrectionModel correctionModel =
          await localDataSource.getCorrectionFromCacheUsingId(
        studentId: studentId,
        textId: textId,
      );

      final List<MistakeModel> mistakeModels = await localDataSource
          .getMistakesFromCacheUsingId(correctionModel.localId);

      final List<Mistake> mistakes =
          mistakeEntityModelConverter.modelsToEntityList(mistakeModels);

      final Correction correction =
          correctionEntityModelConverter.modelToEntity(
        model: correctionModel,
        mistakes: mistakes,
      );
      return Right(correction);
    } on CacheException {
      return Left(CacheFailure());
    } on EmptyDataException {
      return Left(EmptyDataFailure());
    }
  }
}

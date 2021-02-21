import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/audio_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import '../data_sources/audio_local_data_source.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioEntityModelConverter audioEntityModelConverter;
  final AudioLocalDataSource localDataSource;
  final TextEntityModelConverter textEntityModelConverter;

  AudioRepositoryImpl(
      {@required this.localDataSource,
      @required this.audioEntityModelConverter,
      @required this.textEntityModelConverter});

  @override
  Future<Either<Failure, AudioEntity>> createAudio(AudioEntity audio) async {
    try {
      final AudioModel model = audioEntityModelConverter.entityToModel(audio);
      final localModel = await localDataSource.cacheNewAudio(model);
      final localAudio = audioEntityModelConverter.modelToEntity(localModel);
      return Right(localAudio);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAudio(AudioEntity audio) async {
    try {
      var model = audioEntityModelConverter.entityToModel(audio);
      return Right(await localDataSource.deleteAudioFromCache(model));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<AudioEntity>>> getAllAudiosFromStudent(
      Student student) async {
    try {
      final StudentModel studentModel = studentEntityToModel(student);
      var listAudioModel = await localDataSource.getAllAudiosOfStudentFromCache(
        studentModel,
      );
      var listAudioEntity = [
        for (var model in listAudioModel)
          audioEntityModelConverter.modelToEntity(model)
      ];
      return Right(listAudioEntity);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AudioEntity>> getAudio(
      {Student student, MyText text}) async {
    try {
      final StudentModel studentModel = studentEntityToModel(student);
      final TextModel textModel =
          await textEntityModelConverter.mytextEntityToModel(
        text,
      );
      var audioModel = await localDataSource.getAudioFromCache(
        studentModel: studentModel,
        textModel: textModel,
      );
      final AudioEntity audioEntity = audioEntityModelConverter.modelToEntity(
        audioModel,
      );
      return Right(audioEntity);
    } on CacheException {
      return Left(CacheFailure());
    } on EmptyDataException {
      return Left(EmptyDataFailure());
    }
  }

  @override
  Future<Either<Failure, AudioEntity>> updateAudio(AudioEntity audio) async {
    try {
      var model = audioEntityModelConverter.entityToModel(audio);
      var localModel = await localDataSource.updateCachedAudio(model);
      var localAudio = audioEntityModelConverter.modelToEntity(localModel);
      return Right(localAudio);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

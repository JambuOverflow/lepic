import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';

class CreateAudio implements UseCase<AudioEntity, AudioParams> {
  final AudioRepository repository;

  CreateAudio({@required this.repository});

  @override
  Future<Either<Failure, AudioEntity>> call(AudioParams params) =>
      repository.createAudio(params.audio);
}

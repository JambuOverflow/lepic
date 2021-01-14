import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';

class UpdateAudio implements UseCase<AudioEntity, AudioParams> {
  final AudioRepository repository;

  UpdateAudio({@required this.repository});

  @override
  Future<Either<Failure, AudioEntity>> call(AudioParams params) =>
      repository.updateAudio(params.audio);
}

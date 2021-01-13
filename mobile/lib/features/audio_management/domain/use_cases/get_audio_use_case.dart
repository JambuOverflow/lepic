import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';

class GetAudio implements UseCase<AudioEntity, StudentTextParams> {
  final AudioRepository repository;

  GetAudio({@required this.repository});

  @override
  Future<Either<Failure, AudioEntity>> call(
    StudentTextParams params,
  ) =>
      repository.getAudio(
        student: params.student,
        text: params.text,
      );
}

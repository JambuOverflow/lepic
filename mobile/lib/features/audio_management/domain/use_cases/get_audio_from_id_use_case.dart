import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';

class GetAudioFromIdUseCase
    implements UseCase<AudioEntity, CorrectionIdParams> {
  final AudioRepository repository;

  GetAudioFromIdUseCase({@required this.repository});

  @override
  Future<Either<Failure, AudioEntity>> call(
    CorrectionIdParams correctionIdParams,
  ) =>
      repository.getAudioFromId(
        textId: correctionIdParams.textId,
        studentId: correctionIdParams.studentId,
      );
}

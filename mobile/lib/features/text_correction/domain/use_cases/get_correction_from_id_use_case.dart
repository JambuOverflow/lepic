  import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';

class GetCorrectionFromIdUseCase
    implements UseCase<Correction, AudioIdParams> {
  final CorrectionRepository repository;

  GetCorrectionFromIdUseCase({@required this.repository});

  @override
  Future<Either<Failure, Correction>> call(
          AudioIdParams params) =>
      repository.getCorrectionFromId(params.audioId);
}

class AudioIdParams extends Equatable {
  final int audioId;

  AudioIdParams(this.audioId);

  @override
  List<Object> get props => [audioId];
}

class CorrectionIdParams extends Equatable {
  final int textId;
  final int studentId;

  CorrectionIdParams({@required this.textId, @required this.studentId});

  @override
  List<Object> get props => [textId, studentId];
}

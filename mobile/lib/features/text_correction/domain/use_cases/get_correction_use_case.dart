import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class GetCorrectionUseCase
    implements UseCase<Correction, AudioParams> {
  final CorrectionRepository repository;

  GetCorrectionUseCase({@required this.repository});

  @override
  Future<Either<Failure, Correction>> call(
    AudioParams params
  ) =>
      repository.getCorrection(params.audio);
}

class StudentTextParams extends Equatable {
  final MyText text;
  final Student student;

  StudentTextParams({@required this.text, @required this.student});

  @override
  List<Object> get props => [text, student];
}

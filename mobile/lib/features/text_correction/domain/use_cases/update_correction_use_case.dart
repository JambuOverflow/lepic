import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';


class UpdateCorrection implements UseCase<Correction, CorrectionParams> {
  final CorrectionRepository repository;

  UpdateCorrection({@required this.repository});

  @override
  Future<Either<Failure, Correction>> call(CorrectionParams params) =>
      repository.updateCorrection(params.correction);
}

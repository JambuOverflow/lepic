import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import '../../../../core/use_cases/use_case.dart';


class DeleteCorrection implements UseCase<void, CorrectionParams> {
  final CorrectionRepository repository;

  DeleteCorrection({@required this.repository});

  @override
  Future<Either<Failure, void>> call(CorrectionParams params) =>
      repository.deleteCorrection(params.correction);
}

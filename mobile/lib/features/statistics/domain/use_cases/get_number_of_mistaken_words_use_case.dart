import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';

class GetNumberOfMistakenWordsUseCase
    implements UseCase<int, CorrectionParams> {
  @override
  Future<Either<Failure, int>> call(CorrectionParams params) async {
    final Correction correction = params.correction;
    return Right(correction.mistakes.length);
  }
}

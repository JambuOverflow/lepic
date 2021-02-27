import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_class_use_case.dart';


class GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase
    implements UseCase<List<double>, ClassroomParams> {
  final GetAllCorrectionsFromClassUseCase getAllCorrectionsFromClassUseCase;
  final GetNumberOfCorrectWordsReadPerMinuteUseCase
      getNumberOfCorrectWordsReadPerMinuteUseCase;

  GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(
      {@required this.getAllCorrectionsFromClassUseCase,
      @required this.getNumberOfCorrectWordsReadPerMinuteUseCase});

  @override
  Future<Either<Failure, List<double>>> call(ClassroomParams params) async {
    try {
      List<Correction> correctionList = await _getCorrectionlist(params);

      List<double> numCorrectWordReadPerMinute = [];
      for (var i = 0; i < correctionList.length; i++) {
        double localNumCorrectWordReadPerMinute = await _getStatistic(correctionList[i]);
        numCorrectWordReadPerMinute.add(localNumCorrectWordReadPerMinute);
      }
      return Right(numCorrectWordReadPerMinute);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<double> _getStatistic(Correction correction) async {
    final CorrectionParams correctionParams = CorrectionParams(correction: correction);
    double localNumCorrectWordReadPerMinute;
    final statisticOutput =
        await getNumberOfCorrectWordsReadPerMinuteUseCase(correctionParams);
    statisticOutput.fold((l) {
      throw Exception();
    }, (r) {
      localNumCorrectWordReadPerMinute = r;
    });
    return localNumCorrectWordReadPerMinute;
  }

  Future<List<Correction>> _getCorrectionlist(ClassroomParams params) async {
    final correctionOutput = await getAllCorrectionsFromClassUseCase(params);
    List<Correction> correctionList;
    correctionOutput.fold((l) {
      throw Exception();
    }, (r) {
      correctionList = r;
    });
    return correctionList;
  }
}

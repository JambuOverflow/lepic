import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_zscore_of_number_of_words_read_per_minute_use_case.dart';
import 'package:stats/stats.dart';

class GetZscoreIntervalsOfCorrectNumberOfWordsReadPerMinuteUseCase
    implements UseCase<Map, ClassroomParams> {
  final GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase
      getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase;

  GetZscoreIntervalsOfCorrectNumberOfWordsReadPerMinuteUseCase({
    @required this.getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase,
  });

  @override
  Future<Either<Failure, Map<ReadingStatus, double>>> call(
      ClassroomParams params) async {
    try {
      List<double> numberOfCorrectWordsReadPerMinute =
          await _getClassroomStatistic(params.classroom);

      if (numberOfCorrectWordsReadPerMinute.length < 2) {
        return Left(EmptyDataFailure());
      }

      final stats = Stats.fromData(numberOfCorrectWordsReadPerMinute);
      final double mean = stats.average;
      final double standardDevation = stats.standardDeviation;

      final Map<ReadingStatus, double> result = {
        ReadingStatus.majorDeficit: _getValueFromZscore(
          standardDevation,
          mean,
          -2.0,
        ),
        ReadingStatus.moderateDeficit: _getValueFromZscore(
          standardDevation,
          mean,
          -1.6,
        ),
        ReadingStatus.deficit: _getValueFromZscore(
          standardDevation,
          mean,
          -1.5,
        ),
        ReadingStatus.deficitAlert: _getValueFromZscore(
          standardDevation,
          mean,
          -1.0,
        ),
      };
      return Right(result);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  double _getValueFromZscore(
    double standardDevation,
    double mean,
    double value,
  ) {
    return value * standardDevation + mean;
  }

  Future<List<double>> _getClassroomStatistic(Classroom classroom) async {
    final ClassroomParams classroomParams =
        ClassroomParams(classroom: classroom);
    List<double> numberOfCorrectWordsReadPerMinute;
    final statisticOutput =
        await getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(
            classroomParams);
    statisticOutput.fold((l) {
      throw Exception();
    }, (r) {
      numberOfCorrectWordsReadPerMinute = r;
    });
    return numberOfCorrectWordsReadPerMinute;
  }
}

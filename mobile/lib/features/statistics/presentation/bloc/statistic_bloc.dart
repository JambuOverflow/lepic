import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final Student student;
  final GetNumberOfWordsReadPerMinuteUseCase getNumberOfWordsReadPerMinute;
  final GetNumberOfCorrectWordsReadPerMinuteUseCase
      getNumberOfCorrectWordsReadPerMinute;
  final AudioEntity audio;

  String get cardContent =>
      '${student.firstName} ${student.lastName} had his/her fluency assessed in DATE. He/She read the text in X minutes and Y seconds with Z% of correctness.';

  StatisticBloc(
      {@required this.audio,
      @required this.getNumberOfCorrectWordsReadPerMinute,
      @required this.getNumberOfWordsReadPerMinute,
      @required this.student})
      : super(StatisticLoading());

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    if (event is GetStatisticsEvent) yield* _getStatistics(event);
  }

  Stream<StatisticState> _getStatistics(GetStatisticsEvent event) async* {
    final AudioParams audioParams = AudioParams(audio: audio);
    final wordsPerMinutesOrFailure =
        await getNumberOfWordsReadPerMinute(audioParams);
    final correctWordsPerMinutesOrFailure =
        await getNumberOfWordsReadPerMinute(audioParams);

    yield wordsPerMinutesOrFailure.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (numberOfWordsReadPerMinute) {
        return StatisticsLoaded();
      },
    );
    yield correctWordsPerMinutesOrFailure.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (numberOfWordsReadPerMinute) {
        return StatisticsLoaded();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}

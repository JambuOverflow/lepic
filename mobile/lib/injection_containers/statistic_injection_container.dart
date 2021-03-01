import 'package:get_it/get_it.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactoryParam<StatisticBloc, Student, AudioEntity>(
    (student, audio) => StatisticBloc(
      student: student,
      audio: audio,
      getNumberOfCorrectWordsReadPerMinute: getIt(),
      getNumberOfWordsReadPerMinute: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAudioFromIdUseCase(repository: getIt()));

  getIt.registerLazySingleton(
      () => GetNumberOfWordsReadPerMinuteUseCase(getTextUseCase: getIt()));

  getIt.registerLazySingleton(
      () => GetCorrectionFromIdUseCase(repository: getIt()));

  getIt.registerLazySingleton(() => GetNumberOfCorrectWordsReadPerMinuteUseCase(
      getAudioFromIdUseCase: getIt(), getTextUseCase: getIt()));
}

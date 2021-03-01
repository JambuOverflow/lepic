import 'package:get_it/get_it.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_zscore_intervals_of_correct_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_class_use_case.dart';

import '../features/audio_management/domain/entities/audio.dart';
import '../features/audio_management/domain/use_cases/get_all_audios_from_class_use_case.dart';
import '../features/audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import '../features/statistics/domain/use_cases/get_class_list_of_number_of_words_read_per_minute_use_case.dart';
import '../features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import '../features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import '../features/statistics/domain/use_cases/get_zscore_intervals_of_number_of_words_read_per_minute_use_case.dart';
import '../features/statistics/presentation/bloc/line_graph_cubit.dart';
import '../features/statistics/presentation/bloc/statistic_bloc.dart';
import '../features/student_management/domain/entities/student.dart';
import '../features/text_correction/domain/use_cases/get_all_corrections_of_student_use_case.dart';
import '../features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import '../features/text_management/domain/use_cases/get_text_use_case.dart';

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

  getIt.registerFactoryParam<LineGraphCubit, Student, void>(
    (student, _) => LineGraphCubit(
      student: student,
      getClassroomFromId: getIt(),
      getTextUseCase: getIt(),
      getAudioFromIdUseCase: getIt(),
      getAllCorrectionsOfStudent: getIt(),
      getNumberOfWordsRead: getIt(),
      getZscoreIntervalsOfNumberOfWordsRead: getIt(),
      getNumberOfCorrectWordsReadPerMinute: getIt(),
      getZscoreIntervalsOfCorrectWordsReadPerMinute: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetAllCorrectionsOfStudentUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetAllAudiosFromClassUseCase(
      getAllAudiosFromStudentUseCase: getIt(),
      getStudents: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetClassListOfNumberOfWordsReadPerMinuteUseCase(
      getAllAudiosFromClassUseCase: getIt(),
      getNumberOfWordsReadPerMinuteUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetZscoreIntervalsOfNumberOfWordsReadPerMinuteUseCase(
      getClassListOfNumberOfWordsReadPerMinuteUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetZscoreIntervalsOfCorrectNumberOfWordsReadPerMinuteUseCase(
        getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase: getIt()),
  );

  getIt.registerLazySingleton(() => GetTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAudioFromIdUseCase(repository: getIt()));

  getIt.registerLazySingleton(
    () => GetNumberOfWordsReadPerMinuteUseCase(getTextUseCase: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetCorrectionFromIdUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetNumberOfCorrectWordsReadPerMinuteUseCase(
      getAudioFromIdUseCase: getIt(),
      getTextUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetAllCorrectionsFromClassUseCase(
      getAllCorrectionsFromStudentUseCase: getIt(),
      getStudents: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(
      getAllCorrectionsFromClassUseCase: getIt(),
      getNumberOfCorrectWordsReadPerMinuteUseCase: getIt(),
    ),
  );
}

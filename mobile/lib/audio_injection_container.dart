import 'package:get_it/get_it.dart';
import 'package:mobile/features/audio_management/data/data_sources/audio_local_data_source.dart';
import 'package:mobile/features/audio_management/data/repositories/audio_repository_impl.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/create_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_student_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_use_case.dart';

import 'core/data/entity_model_converters/audio_entity_model_converter.dart';
import 'core/data/entity_model_converters/text_entity_model_converter.dart';
import 'features/audio_management/domain/use_cases/delete_audio_use_case.dart';
import 'features/audio_management/domain/use_cases/update_audio_use_case.dart';
import 'features/audio_management/presentation/bloc/audio_bloc.dart';
import 'features/student_management/domain/entities/student.dart';
import 'features/text_management/domain/entities/text.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactoryParam<AudioBloc, MyText, Student>(
    (text, student) => AudioBloc(
      text: text,
      student: student,
      updateAudio: GetIt.instance(),
      deleteAudio: GetIt.instance(),
      createAudio: GetIt.instance(),
      getAudio: GetIt.instance(),
    ),
  );

  sl.registerLazySingleton(() => CreateAudioUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateAudioUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAudioUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAudioUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GetAllAudiosFromStudentUseCase(repository: sl()));

  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(
      localDataSource: sl(),
      audioEntityModelConverter: sl(),
      textEntityModelConverter: sl(),
    ),
  );

  sl.registerFactory(() => AudioEntityModelConverter());

  sl.registerLazySingleton<AudioLocalDataSource>(
    () => AudioLocalDataSourceImpl(
      database: sl(),
    ),
  );
}

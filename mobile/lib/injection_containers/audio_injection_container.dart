import 'package:get_it/get_it.dart';

import '../features/text_correction/domain/use_cases/get_correction_use_case.dart';
import '../features/audio_management/data/data_sources/audio_local_data_source.dart';
import '../features/audio_management/data/repositories/audio_repository_impl.dart';
import '../features/audio_management/domain/repositories/audio_repository.dart';
import '../features/audio_management/domain/use_cases/create_audio_use_case.dart';
import '../features/audio_management/domain/use_cases/get_all_audios_from_student_use_case.dart';
import '../features/audio_management/domain/use_cases/get_audio_use_case.dart';
import '../core/data/entity_model_converters/audio_entity_model_converter.dart';
import '../features/audio_management/domain/use_cases/delete_audio_use_case.dart';
import '../features/audio_management/domain/use_cases/update_audio_use_case.dart';
import '../features/audio_management/presentation/bloc/audio_bloc.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactoryParam<AudioBloc, StudentTextParams, void>(
    (params, _) => AudioBloc(
      text: params.text,
      student: params.student,
      updateAudio: GetIt.instance(),
      deleteAudio: GetIt.instance(),
      createAudio: GetIt.instance(),
      getAudio: GetIt.instance(),
    ),
  );

  getIt.registerLazySingleton(() => CreateAudioUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateAudioUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteAudioUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAudioUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetAllAudiosFromStudentUseCase(repository: getIt()));

  getIt.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(
      localDataSource: getIt(),
      audioEntityModelConverter: getIt(),
      textEntityModelConverter: getIt(),
    ),
  );

  getIt.registerFactory(() => AudioEntityModelConverter());

  getIt.registerLazySingleton<AudioLocalDataSource>(
    () => AudioLocalDataSourceImpl(
      database: getIt(),
    ),
  );
}

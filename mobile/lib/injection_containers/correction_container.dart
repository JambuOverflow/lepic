import 'package:get_it/get_it.dart';
import 'package:mobile/core/data/entity_model_converters/mistake_entity_model_converter.dart';
import 'package:mobile/features/text_correction/domain/use_cases/create_correction_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/delete_correction_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/update_correction_use_case.dart';

import '../features/text_correction/data/data_sources/mistake_local_data_source.dart';
import '../features/text_correction/data/repositories/correction_repository_impl.dart';
import '../features/text_correction/domain/repositories/correction_repository.dart';
import '../features/text_correction/domain/use_cases/get_correction_use_case.dart';
import '../features/text_correction/presentation/bloc/correction_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactoryParam<CorrectionBloc, StudentTextParams, void>(
    (params, _) => CorrectionBloc(
      student: params.student,
      text: params.text,
      getCorrectionUseCase: sl(),
      createCorrectionUseCase: sl(),
      deleteCorrectionUseCase: sl(),
      updateCorrectionUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCorrectionUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateCorrectionUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteCorrectionUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCorrectionUseCase(repository: sl()));

  sl.registerLazySingleton<CorrectionRepository>(
    () => CorrectionRepositoryImpl(
      localDataSource: sl(),
      mistakeEntityModelConverter: sl(),
      textEntityModelConverter: sl(),
    ),
  );

  sl.registerLazySingleton<MistakeLocalDataSource>(
    () => MistakeLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton(() => MistakeEntityModelConverter());
}

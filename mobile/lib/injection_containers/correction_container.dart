import 'package:get_it/get_it.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/presentation/bloc/single_text_cubit.dart';

import '../core/data/entity_model_converters/mistake_entity_model_converter.dart';
import '../features/text_correction/domain/use_cases/create_correction_use_case.dart';
import '../features/text_correction/domain/use_cases/delete_correction_use_case.dart';
import '../features/text_correction/domain/use_cases/update_correction_use_case.dart';
import '../features/text_correction/data/data_sources/mistake_local_data_source.dart';
import '../features/text_correction/data/repositories/correction_repository_impl.dart';
import '../features/text_correction/domain/repositories/correction_repository.dart';
import '../features/text_correction/domain/use_cases/get_correction_use_case.dart';
import '../features/text_correction/presentation/bloc/correction_bloc.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactoryParam<CorrectionBloc, SingleTextCubit, Student>(
    (textCubit, student) => CorrectionBloc(
      student: student,
      textCubit: textCubit,
      getCorrectionUseCase: getIt(),
      createCorrectionUseCase: getIt(),
      deleteCorrectionUseCase: getIt(),
      updateCorrectionUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetCorrectionUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => CreateCorrectionUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => DeleteCorrectionUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => UpdateCorrectionUseCase(repository: getIt()));

  getIt.registerLazySingleton<CorrectionRepository>(
    () => CorrectionRepositoryImpl(
      localDataSource: getIt(),
      mistakeEntityModelConverter: getIt(),
      textEntityModelConverter: getIt(),
    ),
  );

  getIt.registerLazySingleton<MistakeLocalDataSource>(
    () => MistakeLocalDataSourceImpl(database: getIt()),
  );

  getIt.registerLazySingleton(() => MistakeEntityModelConverter());
}

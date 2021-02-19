import 'package:get_it/get_it.dart';

import '../core/data/entity_model_converters/classroom_entity_model_converter.dart';
import '../features/class_management/data/data_sources/classroom_local_data_source.dart';
import '../features/class_management/data/repositories/classroom_repository_impl.dart';
import '../features/class_management/domain/repositories/classroom_repository.dart';
import '../features/class_management/domain/use_cases/create_classroom_use_case.dart';
import '../features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import '../features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import '../features/class_management/domain/use_cases/update_classroom_use_case.dart';
import '../features/class_management/presentation/bloc/classroom_bloc.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactory(
    () => ClassroomBloc(
      authBloc: getIt(),
      inputConverter: getIt(),
      updateClassroom: getIt(),
      deleteClassroom: getIt(),
      createNewClassroom: getIt(),
      getClassrooms: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => CreateClassroom(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateClassroom(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteClassroom(repository: getIt()));
  getIt.registerLazySingleton(() => GetClassrooms(repository: getIt()));

  getIt.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(
      localDataSource: getIt(),
      clock: getIt(),
      clasrooomEntityModelConverter: getIt(),
    ),
  );

  getIt.registerLazySingleton<ClassroomLocalDataSource>(
    () => ClassroomLocalDataSourceImpl(
      database: getIt(),
      userLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => ClassroomEntityModelConverter(userLocalDataSource: getIt()),
  );
}

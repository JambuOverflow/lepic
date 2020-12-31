import 'package:get_it/get_it.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';

import 'features/class_management/presentation/bloc/classroom_bloc.dart';
import 'package:clock/clock.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => ClassroomBloc(
      authBloc: sl(),
      inputConverter: sl(),
      updateClassroom: sl(),
      deleteClassroom: sl(),
      createNewClassroom: sl(),
      getClassrooms: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateClassroom(repository: sl()));
  sl.registerLazySingleton(() => UpdateClassroom(repository: sl()));
  sl.registerLazySingleton(() => DeleteClassroom(repository: sl()));
  sl.registerLazySingleton(() => GetClassrooms(repository: sl()));

  sl.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(
      localDataSource: sl(),
      clock: sl(),
    ),
  );

  sl.registerLazySingleton<ClassroomLocalDataSource>(
    () => ClassroomLocalDataSourceImpl(
      database: sl(),
    ),
  );

  sl.registerLazySingleton(() => Clock());
}

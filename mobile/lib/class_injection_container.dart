import 'package:get_it/get_it.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';
import 'package:mobile/features/class_management/presentation/bloc/class_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => ClassroomBloc(
      updateClassroom: sl(),
      deleteClassroom: sl(),
      createNewClassroom: sl(),
      getClassroom: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateClassroom(repository: sl()));
  sl.registerLazySingleton(() => UpdateClassroom(repository: sl()));
  sl.registerLazySingleton(() => DeleteClassroom(repository: sl()));
  sl.registerLazySingleton(() => GetClassrooms(repository: sl()));

  sl.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ClassroomLocalDataSource>(
    () => ClassroomLocalDataSourceImpl(
      database: sl(),
    ),
  );
}

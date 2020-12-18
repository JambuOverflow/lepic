import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/student_management/data/repositories/student_repository_impl.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => StudentBloc(
      updateStudent: sl(),
      deleteStudent: sl(),
      createStudent: sl(),
      getStudents: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateStudent(repository: sl()));
  sl.registerLazySingleton(() => UpdateStudent(repository: sl()));
  sl.registerLazySingleton(() => DeleteStudent(repository: sl()));
  sl.registerLazySingleton(() => GetStudents(repository: sl()));

  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(
      database: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => Database(openConnection()));
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

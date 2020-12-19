import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/network/network_info.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/repositories/classroom_repository_impl.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/delete_classroom_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';
import 'package:mobile/features/class_management/presentation/bloc/class_bloc.dart';

import 'package:http/http.dart' as http;

final slClassroom = GetIt.instance;

void init() {
  slClassroom.registerFactory(
    () => ClassroomBloc(
      updateClassroom: slClassroom(),
      deleteClassroom: slClassroom(),
      createNewClassroom: slClassroom(),
      getClassroom: slClassroom(),
    ),
  );

  slClassroom
      .registerLazySingleton(() => CreateClassroom(repository: slClassroom()));
  slClassroom
      .registerLazySingleton(() => UpdateClassroom(repository: slClassroom()));
  slClassroom
      .registerLazySingleton(() => DeleteClassroom(repository: slClassroom()));
  slClassroom
      .registerLazySingleton(() => GetClassrooms(repository: slClassroom()));

  slClassroom.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(
      localDataSource: slClassroom(),
    ),
  );

  slClassroom.registerLazySingleton<ClassroomLocalDataSource>(
    () => ClassroomLocalDataSourceImpl(
      database: slClassroom(),
    ),
  );
/*
  slClassroom
      .registerLazySingleton<NetworkInfo>(() => NetworkInfo(slClassroom()));
  slClassroom.registerLazySingleton(() => Database(openConnection()));
  slClassroom.registerLazySingleton(() => FlutterSecureStorage());
  slClassroom.registerLazySingleton(() => http.Client());
  slClassroom.registerLazySingleton(() => DataConnectionChecker());
  */
}

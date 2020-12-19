import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/network/network_info.dart';

import 'package:http/http.dart' as http;
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => TextBloc(
      updateText: sl(),
      deleteText: sl(),
      createText: sl(),
      getTexts: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateText(repository: sl()));
  sl.registerLazySingleton(() => UpdateText(repository: sl()));
  sl.registerLazySingleton(() => DeleteText(repository: sl()));
  sl.registerLazySingleton(() => GetTexts(repository: sl()));

  sl.registerLazySingleton<TextRepository>(
    () => TextRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TextLocalDataSource>(
    () => TextLocalDataSourceImpl(
      database: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => Database(openConnection()));
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
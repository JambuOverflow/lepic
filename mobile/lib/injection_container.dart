import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/user_management/domain/use_cases/login.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_form_bloc.dart';
import 'core/data/database.dart';
import 'features/user_management/data/data_sources/user_local_data_source.dart';
import 'features/user_management/data/data_sources/user_remote_data_source.dart';
import 'features/user_management/data/repositories/user_repository_impl.dart';
import 'features/user_management/domain/repositories/user_repository.dart';
import 'features/user_management/domain/use_cases/create_user_use_case.dart';
import 'features/user_management/domain/use_cases/get_stored_user_use_case.dart';
import 'features/user_management/domain/use_cases/update_user_use_case.dart';
import 'features/user_management/presentation/bloc/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';

void setUpLocator() {
  final getIt = GetIt.instance;

  getIt.registerFactory(
    () => UserBloc(
      createNewUser: getIt(),
      login: getIt(),
      updateUser: getIt(),
    ),
  );

  getIt.registerFactory(() => UserFormBloc(createNewUser: getIt()));

  getIt.registerLazySingleton(() => CreateNewUserCase(repository: getIt()));
  getIt.registerLazySingleton(() => LoginCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateUserCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetStoredUserCase(repository: getIt()));

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(database: getIt(), secureStorage: getIt()),
  );
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo(getIt()));
  getIt.registerLazySingleton(() => Database(openConnection()));
  getIt.registerLazySingleton(() => FlutterSecureStorage());
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => DataConnectionChecker());
}

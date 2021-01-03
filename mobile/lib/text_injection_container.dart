import 'package:get_it/get_it.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';

import 'features/text_management/presentation/bloc/text_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactoryParam<TextBloc, Classroom, void>(
    (classroom, _) => TextBloc(
      classroom: classroom,
      updateText: GetIt.instance(),
      deleteText: GetIt.instance(),
      createText: GetIt.instance(),
      getTextsOfClassroom: GetIt.instance(),
    ),
  );

  sl.registerLazySingleton(() => CreateText(repository: sl()));
  sl.registerLazySingleton(() => UpdateText(repository: sl()));
  sl.registerLazySingleton(() => DeleteText(repository: sl()));
  sl.registerLazySingleton(() => GetTexts(repository: sl()));

  sl.registerLazySingleton<TextRepository>(
    () => TextRepositoryImpl(
      localDataSource: sl(),
      classroomEntityModelConverter: sl(),
    ),
  );

  sl.registerLazySingleton<TextLocalDataSource>(
    () => TextLocalDataSourceImpl(
      database: sl(),
    ),
  );
}

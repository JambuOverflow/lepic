import 'package:get_it/get_it.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_student_texts_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';

import 'features/text_management/presentation/bloc/text_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactoryParam<TextBloc, Student, void>(
    (student, _) => TextBloc(
      student: student,
      updateText: GetIt.instance(),
      deleteText: GetIt.instance(),
      createText: GetIt.instance(),
      getTextsOfClassroom: GetIt.instance(),
    ),
  );

  sl.registerLazySingleton(() => CreateTextUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTextUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTextUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetStudentTextsUseCase(repository: sl()));

  sl.registerLazySingleton<TextRepository>(
    () => TextRepositoryImpl(
      localDataSource: sl(),
      studentEntityModelConverter: sl(),
      textEntityModelConverter: sl(),
    ),
  );

  sl.registerLazySingleton<TextLocalDataSource>(
    () => TextLocalDataSourceImpl(
      database: sl(),
      userLocalDataSource: sl(),
    ),
  );

  sl.registerFactory(() => TextEntityModelConverter(userLocalDataSource: sl()));
}

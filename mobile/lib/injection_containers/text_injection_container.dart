import 'package:get_it/get_it.dart';

import '../core/data/entity_model_converters/student_entity_model_converter.dart';
import '../core/data/entity_model_converters/text_entity_model_converter.dart';
import '../features/student_management/domain/entities/student.dart';
import '../features/text_management/data/data_sources/text_local_data_source.dart';
import '../features/text_management/data/repositories/text_repository_impl.dart';
import '../features/text_management/domain/repositories/text_repository.dart';
import '../features/text_management/domain/use_cases/create_text_use_case.dart';
import '../features/text_management/domain/use_cases/delete_text_use_case.dart';
import '../features/text_management/domain/use_cases/get_student_texts_use_case.dart';
import '../features/text_management/domain/use_cases/update_text_use_case.dart';
import '../features/text_management/presentation/bloc/text_bloc.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactoryParam<TextBloc, Student, void>(
    (student, _) => TextBloc(
      student: student,
      updateText: GetIt.instance(),
      deleteText: GetIt.instance(),
      createText: GetIt.instance(),
      getTextsOfClassroom: GetIt.instance(),
    ),
  );

  getIt.registerLazySingleton(() => CreateTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteTextUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => GetStudentTextsUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<TextRepository>(
    () => TextRepositoryImpl(
      localDataSource: getIt(),
      studentEntityModelConverter: getIt(),
      textEntityModelConverter: getIt(),
    ),
  );

  getIt.registerLazySingleton<TextLocalDataSource>(
    () => TextLocalDataSourceImpl(
      database: getIt(),
      userLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => StudentEntityModelConverter());
  getIt.registerLazySingleton(
    () => TextEntityModelConverter(userLocalDataSource: getIt()),
  );
}

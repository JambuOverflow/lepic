import 'package:get_it/get_it.dart';

import '../features/class_management/domain/entities/classroom.dart';
import '../features/student_management/data/data_sources/student_local_data_source.dart';
import '../features/student_management/data/repositories/student_repository_impl.dart';
import '../features/student_management/domain/repositories/student_repository.dart';
import '../features/student_management/domain/use_cases/create_student_use_case.dart';
import '../features/student_management/domain/use_cases/delete_student_use_case.dart';
import '../features/student_management/domain/use_cases/get_students_use_case.dart';
import '../features/student_management/domain/use_cases/update_student_use_case.dart';
import '../features/student_management/presentation/bloc/student_bloc.dart';

void init() {
  final getIt = GetIt.instance;

  getIt.registerFactoryParam<StudentBloc, Classroom, void>(
    (classroom, _) => StudentBloc(
      classroom: classroom,
      createStudent: GetIt.instance(),
      deleteStudent: GetIt.instance(),
      getStudents: GetIt.instance(),
      updateStudent: GetIt.instance(),
    ),
  );

  getIt.registerLazySingleton(() => CreateStudent(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateStudent(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteStudent(repository: getIt()));
  getIt.registerLazySingleton(() => GetStudents(repository: getIt()));

  getIt.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      localDataSource: getIt(),
      classroomEntityModelConverter: getIt(),
    ),
  );

  getIt.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(
      database: getIt(),
    ),
  );
}

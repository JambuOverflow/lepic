import 'package:get_it/get_it.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/student_management/data/repositories/student_repository_impl.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

final slStudent = GetIt.instance;

void init() {
  slStudent.registerFactory(
    () => StudentBloc(
      updateStudent: slStudent(),
      deleteStudent: slStudent(),
      createStudent: slStudent(),
      getStudents: slStudent(),
    ),
  );

  slStudent.registerLazySingleton(() => CreateStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => UpdateStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => DeleteStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => GetStudents(repository: slStudent()));

  slStudent.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      localDataSource: slStudent(),
    ),
  );

  slStudent.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(
      database: slStudent(),
    ),
  );
}

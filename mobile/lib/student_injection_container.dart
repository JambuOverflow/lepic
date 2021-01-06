import 'package:get_it/get_it.dart';
import 'package:mobile/features/student_management/data/data_sources/student_local_data_source.dart';
import 'package:mobile/features/student_management/data/repositories/student_repository_impl.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'features/class_management/domain/entities/classroom.dart';


final slStudent = GetIt.instance;

void init() {
  slStudent.registerFactoryParam<StudentBloc, Classroom, void>(
    (classroom, _) => StudentBloc(
      classroom: classroom,
      createStudent: GetIt.instance(),
      deleteStudent: GetIt.instance(),
      getStudents: GetIt.instance(),
      updateStudent: GetIt.instance(),
    ),
  );

  slStudent.registerLazySingleton(() => CreateStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => UpdateStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => DeleteStudent(repository: slStudent()));
  slStudent.registerLazySingleton(() => GetStudents(repository: slStudent()));

  slStudent.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      localDataSource: slStudent(),
      classroomEntityModelConverter: slStudent(),
    ),
  );

  slStudent.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(
      database: slStudent(),
    ),
  );
}

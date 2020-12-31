import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mockito/mockito.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  GetStudents useCase;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    useCase = GetStudents(repository: mockStudentRepository);
  });

  final tClassroom = Classroom(grade: 1, name: "Dex", id: 1);

  final tStudent1 =
      Student(firstName: '1', lastName: 'klinton', classroomId: 1, id: 2);
  final tStudent2 =
      Student(firstName: '2', lastName: 'canavarro', classroomId: 1, id: 2);

  final List<Student> tTwoStudents = [tStudent1, tStudent2];
  final List<Student> tEmptyStudents = [];

  test(
      'should return an empty list of students if the professor don"t have students',
      () async {
    when(mockStudentRepository.getStudents(tClassroom))
        .thenAnswer((_) async => Right(tEmptyStudents));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tEmptyStudents));
    verify(mockStudentRepository.getStudents(tClassroom));
    verifyNoMoreInteractions(mockStudentRepository);
  });

  test('should return list of classrooms', () async {
    when(mockStudentRepository.getStudents(tClassroom))
        .thenAnswer((_) async => Right(tTwoStudents));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tTwoStudents));
    verify(mockStudentRepository.getStudents(tClassroom));
    verifyNoMoreInteractions(mockStudentRepository);
  });
}

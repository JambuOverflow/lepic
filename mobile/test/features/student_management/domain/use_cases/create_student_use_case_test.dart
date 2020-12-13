import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/create_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mockito/mockito.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  CreateStudent useCase;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    useCase = CreateStudent(repository: mockStudentRepository);
  });

  final tStudent = Student(
    firstName: "Miguel",
    lastName: "ito",
    classroomId: 1,
    id: 1,
  );

  test('should return a student when creating it', () async {
    when(mockStudentRepository.createStudent(tStudent))
        .thenAnswer((_) async => Right(tStudent));

    final result = await useCase(StudentParams(student: tStudent));

    expect(result, Right(tStudent));
    verify(mockStudentRepository.createStudent(tStudent));
    verifyNoMoreInteractions(mockStudentRepository);
  });
}

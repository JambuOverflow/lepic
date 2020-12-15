import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/student_management/domain/use_cases/update_student_use_case.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mockito/mockito.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  UpdateStudent useCase;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    useCase = UpdateStudent(repository: mockStudentRepository);
  });

  final tStudent = Student(
    firstName: 'v',
    lastName: 'c',
    classroomId: 1,
    id: 2,
  );

  test('should return a correct response when updating a classroom', () async {
    when(mockStudentRepository.updateStudent(tStudent))
        .thenAnswer((_) async => Right(tStudent));

    final result = await useCase(StudentParams(student: tStudent));

    expect(result, Right(tStudent));
    verify(mockStudentRepository.updateStudent(tStudent));
    verifyNoMoreInteractions(mockStudentRepository);
  });
}

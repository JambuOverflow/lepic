import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/delete_student_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mockito/mockito.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  DeleteStudent useCase;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    useCase = DeleteStudent(repository: mockStudentRepository);
  });

  final tStudent = Student(
    firstName: 'Miguel',
    lastName: 'Yoshikawa',
    classroomId: 1,
    id: 1,
  );

  test('should return nothing when deleting a classroom', () async {
    await useCase(StudentParams(student: tStudent));

    verify(mockStudentRepository.deleteStudent(tStudent));
    verifyNoMoreInteractions(mockStudentRepository);
  });
}

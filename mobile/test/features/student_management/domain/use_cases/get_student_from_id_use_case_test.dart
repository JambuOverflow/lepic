import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_student_from_id_use_case.dart';
import 'package:mockito/mockito.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  GetStudentFromId useCase;
  MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    useCase = GetStudentFromId(repository: mockStudentRepository);
  });


  final tStudent1 =
      Student(firstName: '1', lastName: 'klinton', classroomId: 1, id: 1);



  test(
      'should return a student',
      () async {
    when(mockStudentRepository.getStudentFromId(1))
        .thenAnswer((_) async => Right(tStudent1));

    final result = await useCase(1);

    expect(result, Right(tStudent1));
    verify(mockStudentRepository.getStudentFromId(1));
    verifyNoMoreInteractions(mockStudentRepository);
  });
}

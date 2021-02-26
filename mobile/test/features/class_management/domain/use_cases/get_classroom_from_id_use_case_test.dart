import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classroom_from_id_use_case.dart';
import 'package:mockito/mockito.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  GetClassroomFromId useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = GetClassroomFromId(repository: mockClassroomRepository);
  });

  final tClassroom1 = Classroom(grade: 1, name: "A", id: 1);


  test('should return an empty list of classrooms if there is no classroom',
      () async {
    when(mockClassroomRepository.getClassroomFromId(1))
        .thenAnswer((_) async => Right(tClassroom1));

    final result = await useCase(1);

    expect(result, Right(tClassroom1));
    verify(mockClassroomRepository.getClassroomFromId(1));
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

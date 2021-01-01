import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mockito/mockito.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  GetClassrooms useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = GetClassrooms(repository: mockClassroomRepository);
  });

  final tClassroom1 = Classroom(grade: 1, name: "A", id: 1);
  final tClassroom2 = Classroom(grade: 1, name: "B", id: 2);

  final List<Classroom> tTwoClassrooms = [tClassroom1, tClassroom2];
  final List<Classroom> tEmptyClassrooms = [];

  test('should return an empty list of classrooms if there is no classroom',
      () async {
    when(mockClassroomRepository.getClassrooms())
        .thenAnswer((_) async => Right(tEmptyClassrooms));

    final result = await useCase(NoParams());

    expect(result, Right(tEmptyClassrooms));
    verify(mockClassroomRepository.getClassrooms());
    verifyNoMoreInteractions(mockClassroomRepository);
  });

  test('should return list of classrooms', () async {
    when(mockClassroomRepository.getClassrooms())
        .thenAnswer((_) async => Right(tTwoClassrooms));

    final result = await useCase(NoParams());

    expect(result, Right(tTwoClassrooms));
    verify(mockClassroomRepository.getClassrooms());
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

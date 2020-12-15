import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/create_classroom_use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  CreateClassroom useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = CreateClassroom(repository: mockClassroomRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tClassroom = Classroom(
    tutorId: 1,
    grade: 1,
    name: "A",
    id: 1,
  );

  test('should return a correct response when creating a classroom', () async {
    when(mockClassroomRepository.createClassroom(tClassroom))
        .thenAnswer((_) async => Right(tClassroom));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tClassroom));
    verify(mockClassroomRepository.createClassroom(tClassroom));
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

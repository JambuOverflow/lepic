import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/create_school_use_case.dart';
import 'package:mobile/features/school_management/domain/use_cases/school_params.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockClassroomRepository extends Mock implements SchoolRepository {}

void main() {
  CreateSchool useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = CreateSchool(repository: mockClassroomRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tSchool = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );
  test('should return a correct response when creating a school', () async {
    when(mockClassroomRepository.createSchool(tSchool))
        .thenAnswer((_) async => Right(tSchool));

    final result = await useCase(SchoolParams(school: tSchool));

    expect(result, Right(tSchool));
    verify(mockClassroomRepository.createSchool(tSchool));
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

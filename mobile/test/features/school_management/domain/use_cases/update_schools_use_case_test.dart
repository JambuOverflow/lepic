import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/update_classroom_use_case.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/school_params.dart';
import 'package:mobile/features/school_management/domain/use_cases/update_school_use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockSchoolRepository extends Mock implements SchoolRepository {}

void main() {
  UpdateSchool useCase;
  MockSchoolRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockSchoolRepository();
    useCase = UpdateSchool(repository: mockClassroomRepository);
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
    modality: Modality.estadual,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  test('should return a correct response when updating a school', () async {
    when(mockClassroomRepository.updateSchool(tSchool))
        .thenAnswer((_) async => Right(tSchool));

    final result = await useCase(SchoolParams(school: tSchool));

    expect(result, Right(tSchool));
    verify(mockClassroomRepository.updateSchool(tSchool));
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

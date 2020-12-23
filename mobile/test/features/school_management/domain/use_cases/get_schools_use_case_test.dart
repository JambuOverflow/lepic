import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/get_schools_use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockSchoolRepository extends Mock implements SchoolRepository {}

void main() {
  GetSchools useCase;
  MockSchoolRepository mockSchoolRepository;

  setUp(() {
    mockSchoolRepository = MockSchoolRepository();
    useCase = GetSchools(repository: mockSchoolRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tSchool1 = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.estadual,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchool2 = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.estadual,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final List<School> tTwoSchools = [tSchool1, tSchool2];
  final List<School> tEmptySchools = [];

  test('should return an empty list of schools if there is no schools',
      () async {
    when(mockSchoolRepository.getSchools(tUser))
        .thenAnswer((_) async => Right(tEmptySchools));

    final result = await useCase(UserParams(tUser));

    expect(result, Right(tEmptySchools));
    verify(mockSchoolRepository.getSchools(tUser));
    verifyNoMoreInteractions(mockSchoolRepository);
  });

  test('should return list of schools', () async {
    when(mockSchoolRepository.getSchools(tUser))
        .thenAnswer((_) async => Right(tTwoSchools));

    final result = await useCase(UserParams(tUser));

    expect(result, Right(tTwoSchools));
    verify(mockSchoolRepository.getSchools(tUser));
    verifyNoMoreInteractions(mockSchoolRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/delete_school_use_case.dart';
import 'package:mobile/features/school_management/domain/use_cases/school_params.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClassroomRepository extends Mock implements SchoolRepository {}

void main() {
  DeleteSchool useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = DeleteSchool(repository: mockClassroomRepository);
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
  test('should return nothing when deleting a school', () async {
    await useCase(SchoolParams(school: tSchool));

    verify(mockClassroomRepository.deleteSchool(tSchool));
    verifyNoMoreInteractions(mockClassroomRepository);
  });
}

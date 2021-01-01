import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classrooms_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/sync_classrooms_use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';
import 'package:mockito/mockito.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  SyncClassrooms useCase;
  MockClassroomRepository mockClassroomRepository;

  setUp(() {
    mockClassroomRepository = MockClassroomRepository();
    useCase = SyncClassrooms(repository: mockClassroomRepository);
  });

  test('should run without server failure', () async {
    when(mockClassroomRepository.syncClassrooms())
        .thenAnswer((_) async => Right(null));

    await useCase(NoParams());

    equals(true);
    verify(mockClassroomRepository.syncClassrooms());
    verifyNoMoreInteractions(mockClassroomRepository);
  });

  test('should return a server failure', () async {
    when(mockClassroomRepository.syncClassrooms())
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(NoParams());

    expect(result, Left(ServerFailure()));
    verify(mockClassroomRepository.syncClassrooms());
    verifyNoMoreInteractions(mockClassroomRepository);
  });

}

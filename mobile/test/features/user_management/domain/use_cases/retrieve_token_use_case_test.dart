import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/repositories/user_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/retrieve_token_use_case.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  RetrieveTokenUseCase useCase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = RetrieveTokenUseCase(repository: mockUserRepository);
  });

  test('should get user token from the repository', () async {
    final tToken = 'secret token';
    when(mockUserRepository.retrieveToken())
        .thenAnswer((_) async => Right(tToken));

    final result = await useCase(NoParams());

    expect(result, Right(tToken));

    verify(mockUserRepository.retrieveToken());
    verifyNoMoreInteractions(mockUserRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/repositories/user_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/retrieve_token_use_case.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  RetrieveTokenUseCase useCase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = RetrieveTokenUseCase(repository: mockUserRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  test('should get user token from the repository', () async {
    final tToken = 'secret token';
    when(mockUserRepository.retrieveToken(tUser))
        .thenAnswer((_) async => Right(tToken));

    final result = await useCase(UserParams(user: tUser));

    expect(result, Right(tToken));

    verify(mockUserRepository.retrieveToken(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/repositories/user_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/create_new_user.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  CreateNewUser useCase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = CreateNewUser(repository: mockUserRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  test('should send new user to the repository', () async {
    when(mockUserRepository.createUser(tUser))
        .thenAnswer((_) async => Right(tUser));

    final result = await useCase(Params(user: tUser));

    expect(result, Right(tUser));
    verify(mockUserRepository.createUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
}

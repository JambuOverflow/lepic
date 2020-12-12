import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/repositories/user_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_stored_user.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  GetStoredUserCase useCase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetStoredUserCase(repository: mockUserRepository);
  });

  final tUser = User(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );
  
  test('should send new user to the repository with successful response',
      () async {
    when(mockUserRepository.getStoredUser())
        .thenAnswer((_) async => Right(tUser));

    final result = await useCase(NoParams());

    expect(result, Right(tUser));
    verify(mockUserRepository.getStoredUser());
    verifyNoMoreInteractions(mockUserRepository);
  });
}

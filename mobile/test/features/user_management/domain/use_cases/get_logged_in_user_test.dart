import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/domain/repositories/user_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/get_logged_in_user_use_case.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  GetLoggedInUserCase useCase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetLoggedInUserCase(repository: mockUserRepository);
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
    when(mockUserRepository.getLoggedInUser())
        .thenAnswer((_) async => Right(tUser));

    final result = await useCase(NoParams());

    expect(result, Right(tUser));
    verify(mockUserRepository.getLoggedInUser());
    verifyNoMoreInteractions(mockUserRepository);
  });
}

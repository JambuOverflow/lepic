import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
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

  final tResponse = http.Response('Yay', 200);

  test('should send new user to the repository with successful response',
      () async {
    when(mockUserRepository.createUser(tUser))
        .thenAnswer((_) async => Right(tResponse));

    final result = await useCase(Params(user: tUser));

    expect(result, Right(tResponse));
    verify(mockUserRepository.createUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });
}

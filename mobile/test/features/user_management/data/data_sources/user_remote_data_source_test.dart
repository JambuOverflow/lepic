import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  UserRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  final tUserModel = UserModel(
    id: 1,
    firstName: 'ab',
    lastName: 'c',
    email: 'abc@g.com',
    username: 'abc@g.com',
    role: Role.teacher,
    password: 'x1y2',
  );

  final tToken = fixture('token');

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);

    moorRuntimeOptions.defaultSerializer = UserSerializer();
  });

  group('createUser', () {
    test('should perform a POST request and receive a valid response',
        () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('User was born!', 201));

      final result = await dataSource.createUser(tUserModel);

      expect(result, SuccessfulResponse());
    });

    test(
        'should perform an invalid POST request and receive a 400 code response',
        () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('no username', 400));

      final result = await dataSource.createUser(tUserModel);

      expect(result, UnsuccessfulResponse(message: '', statusCode: 400));
    });

    test('''should perform an invalid POST request and receive
        return EmailAlreadyExists when email is duplicated.''', () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response('"email": ["already exists"]', 400));

      final result = await dataSource.createUser(tUserModel);

      expect(result, EmailAlreadyExists());
    });
  });

  group('updateUser', () {
    final tUserUpdatedModel = UserModel(
      id: 1,
      firstName: 'ab',
      lastName: 'c',
      email: 'a@g.com',
      username: 'a@g.com',
      role: Role.researcher,
      password: 'x1y2',
    );

    test('''should perform a valid PATCH request with auth token 
    and receive a 200 code response''', () async {
      when(mockHttpClient.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await dataSource.updateUser(tUserUpdatedModel, '');

      expect(result, SuccessfulResponse());
    });

    test('''should perform an invalid PATCH request and receive a 
    400 code response''', () async {
      when(mockHttpClient.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('no username', 400));

      final result = await dataSource.updateUser(tUserUpdatedModel, '');

      expect(result, UnsuccessfulResponse(message: '', statusCode: 400));
    });
  });

  group('login', () {
    final tBody = jsonEncode({
      "username": tUserModel.email,
      "password": tUserModel.password,
    });

    test('''should perform a valid POST request with 200 code
        and receive an authentication token''', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: tBody))
          .thenAnswer((_) async => http.Response(tToken, 200));

      final result = await dataSource.login(tUserModel);

      expect(result, TokenResponse(token: tToken));
    });

    test('''should perform a valid POST request with invalid info
        and receive a 400 code response''', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: tBody))
          .thenAnswer((_) async => http.Response('non_field_errors', 400));

      final result = await dataSource.login(tUserModel);

      expect(result, InvalidCredentials());
    });

    test('''should perform an invalid POST request and receive 
    a 400 code response''', () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('no username', 400));

      final result = await dataSource.login(tUserModel);

      expect(result, UnsuccessfulResponse(message: '', statusCode: 400));
    });

    test('''should throw server exception when a valid POST 
        request receives an invalid token''', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: tBody))
          .thenAnswer((_) async => http.Response('foobar', 200));

      final call = dataSource.login;

      expect(() => call(tUserModel), throwsA(isA<ServerException>()));
    });
  });

  group('getUser', () {
    test('''should perform a valid GET with auth token and receive 200 code
        and user''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(tUserModel.toJsonString(), 200),
      );

      final result = await dataSource.getUser(tToken);

      expect(result, tUserModel);
    });

    test('''should throw server exception when a valid GET 
        request receives an invalid token''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Unauthorized', 401));

      final call = dataSource.getUser;

      expect(() => call(tToken), throwsA(isA<ServerException>()));
    });
  });
}

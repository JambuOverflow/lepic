import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/data/database.dart';
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

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);

    moorRuntimeOptions.defaultSerializer = UserSerializer();
  });

  group('createUser', () {
    final tUserModel = UserModel(
      localId: 1,
      firstName: 'ab',
      lastName: 'c',
      email: 'abc@g.com',
      role: Role.teacher,
      password: 'x1y2',
    );

    final jsonUser = fixture('user');

    test('should perform a POST request and receive a valid response',
        () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(jsonUser, 201));

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
  });

  group('updateUser', () {
    final tUserUpdatedModel = UserModel(
      localId: 1,
      firstName: 'ab',
      lastName: 'c',
      email: 'a@g.com',
      role: Role.researcher,
      password: 'x1y2',
    );

    test('should perform a valid PATCH request and receive a 200 code response',
        () async {
      when(mockHttpClient.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await dataSource.updateUser(tUserUpdatedModel, '');

      expect(result, SuccessfulResponse());
    });

    test(
        'should perform an invalid PATCH request and receive a 400 code response',
        () async {
      when(mockHttpClient.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('no username', 400));

      final result = await dataSource.updateUser(tUserUpdatedModel, '');

      expect(result, UnsuccessfulResponse(message: '', statusCode: 400));
    });
  });
}

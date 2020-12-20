import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockClassroomLocalDataSourceIml extends Mock
    implements ClassroomLocalDataSourceImpl {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  MockClient mockClient;
  SyncClassroom syncClassroom;
  MockSecureStorage mockSecureStorage;
  MockClassroomLocalDataSourceIml mockClassroomLocalDataSourceIml;
  final token = "cleidson";
  final validResponse = http.Response("[]", 200);
  final invalidResponse = http.Response("[]", 401);
  final queryParameters = {'last_sync_time': "0"};
  final uri = Uri.http(API_URL, 'api/classes/', queryParameters);
  final headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "token cleidson",
  };

  setUp(() async {
    mockClient = MockClient();
    mockSecureStorage = MockSecureStorage();
    syncClassroom = SyncClassroom(
        client: mockClient,
        secureStorage: mockSecureStorage,
        classroomLocalDataSourceImpl: mockClassroomLocalDataSourceIml);
  });

  group('getServerUpdated', () {
    test('should return a correct response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => validResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.getServerUpdated("0");

      verify(mockClient.get(uri, headers: headers));
      verify(mockSecureStorage.read(key: "token"));
      expect(response, validResponse);
    });

    test('should return an error response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.getServerUpdated("0");

      verify(mockClient.get(uri, headers: headers));
      verify(mockSecureStorage.read(key: "token"));
      expect(response, invalidResponse);
    });
  });
}

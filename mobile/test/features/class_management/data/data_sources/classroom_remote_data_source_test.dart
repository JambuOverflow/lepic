import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../core/fixtures/fixture_reader.dart';

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
  final validResponseWithContent =
      http.Response(fixture("server_classrooms"), 200);
  final invalidResponse = http.Response("", 401);
  Uri uri;
  Map<String, String> queryParameters;

  final headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "token cleidson",
  };

  final model1 = ClassroomModel(localId: 1, grade: 1, name: "A", tutorId: 1);
  final model2 = ClassroomModel(localId: 2, grade: 1, name: "B", tutorId: 1);

  setUp(() async {
    mockClient = MockClient();
    mockSecureStorage = MockSecureStorage();
    mockClassroomLocalDataSourceIml = MockClassroomLocalDataSourceIml();
    syncClassroom = SyncClassroom(
        client: mockClient,
        secureStorage: mockSecureStorage,
        classroomLocalDataSourceImpl: mockClassroomLocalDataSourceIml);
    queryParameters = {'last_sync_time': syncClassroom.lastSyncTime.toString()};
    uri = Uri.http(API_URL, 'api/classes/', queryParameters);
  });

  group('getServerUpdated', () {
    test('should return a correct response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => validResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom
          .getServerUpdated(syncClassroom.lastSyncTime.toString());

      verify(mockClient.get(uri, headers: headers));
      verify(mockSecureStorage.read(key: "token"));
      expect(response, validResponse);
    });

    test('should return an error response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom
          .getServerUpdated(syncClassroom.lastSyncTime.toString());

      verify(mockClient.get(uri, headers: headers));
      verify(mockSecureStorage.read(key: "token"));
      expect(response, invalidResponse);
    });
  });
  group('pull', () {
    test('should return a correct response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => validResponseWithContent);
      when(mockClassroomLocalDataSourceIml.cacheClassroom(model1))
          .thenAnswer((_) async => model1);
      when(mockClassroomLocalDataSourceIml.cacheClassroom(model2))
          .thenAnswer((_) async => model2);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.pull();

      verifyInOrder([
        mockClassroomLocalDataSourceIml.cacheClassroom(model1),
        mockClassroomLocalDataSourceIml.cacheClassroom(model2)
      ]);
      expect(response, SuccessfulResponse());
    });

    test('should return a wrong response with the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.pull();

      expect(response, UnsuccessfulResponse(message: ""));
    });
  });
}

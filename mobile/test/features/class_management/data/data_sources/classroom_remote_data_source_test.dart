import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/core/network/url.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

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
  final validResponsePush =
      http.Response(fixture("server_classrooms_push"), 200);
  final invalidResponse = http.Response("", 401);
  String uri;

  final headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "token cleidson",
  };

  final model1 = ClassroomModel(localId: 1, grade: 1, title: "A", tutorId: 1);
  final model1Server =
      ClassroomModel(localId: 1, grade: 1, title: "C", tutorId: 1);
  final model2 = ClassroomModel(localId: 2, grade: 1, title: "B", tutorId: 1);

  setUp(() async {
    mockClient = MockClient();
    mockSecureStorage = MockSecureStorage();
    mockClassroomLocalDataSourceIml = MockClassroomLocalDataSourceIml();
    syncClassroom = SyncClassroom(
        client: mockClient,
        secureStorage: mockSecureStorage,
        classroomLocalDataSourceImpl: mockClassroomLocalDataSourceIml,
        api_url: API_URL);
    uri = API_URL + 'classes/' + "?last_sync=${syncClassroom.lastSyncTime.toString()}";
  });

  group('getServerUpdated', () {
    test('should return a correct response from the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => validResponse);

      final response = await syncClassroom.getServerUpdated(
          syncClassroom.lastSyncTime.toString(), token);

      verify(mockClient.get(uri, headers: headers));
      expect(response, validResponse);
    });

    test('should return an error response from the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.getServerUpdated(
          syncClassroom.lastSyncTime.toString(), token);

      verify(mockClient.get(uri, headers: headers));
      //verify(mockSecureStorage.read(key: "token"));
      expect(response, invalidResponse);
    });
  });

  group('postClassroom', () {
    test('should return a correct response from the server', () async {
      final url = API_URL + 'classes/';
      final body = json.encode(model1.toJson());
      when(mockClient.post(url, headers: headers, body: body))
          .thenAnswer((_) async => validResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      await syncClassroom.postClassroom(model1, token);

      verify(
        mockClient.post(
          url,
          headers: headers,
          body: body,
        ),
      );
      //verify(mockSecureStorage.read(key: "token"));
    });

    test('should throw a server exception', () async {
      final url = API_URL + 'classes/';
      final body = json.encode(model1.toJson());
      when(mockClient.post(url, headers: headers, body: body))
          .thenAnswer((_) async => invalidResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      expect(() async => await syncClassroom.postClassroom(model1, token),
          throwsA(TypeMatcher<ServerException>()));

      //verify(mockSecureStorage.read(key: "token"));
    });
  });

  group('putClassroom', () {
    test('should return a correct response from the server', () async {
      final url = API_URL + 'classes/';
      final body = json.encode(model1.toJson());
      when(mockClient.put(url, headers: headers, body: body))
          .thenAnswer((_) async => validResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      await syncClassroom.putClassroom(model1, token);

      verify(
        mockClient.put(
          url,
          headers: headers,
          body: body,
        ),
      );
      //verify(mockSecureStorage.read(key: "token"));
    });

    test('should throw a server exception', () async {
      final url = API_URL + 'classes/';
      final body = json.encode(model1.toJson());
      when(mockClient.put(url, headers: headers, body: body))
          .thenAnswer((_) async => invalidResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      expect(() async => await syncClassroom.putClassroom(model1, token),
          throwsA(TypeMatcher<ServerException>()));

      //verify(mockSecureStorage.read(key: "token"));
    });
  });

  group('pull', () {
    test('should return a correct response from the server', () async {
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

    test('should return a wrong response from the server', () async {
      when(mockClient.get(uri, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.pull();

      expect(response, UnsuccessfulResponse(message: ""));
    });
  });

  group('getClassroomsInServer', () {
    test('should throw an exception', () async {
      final uriLocal = API_URL +  'classes/';
      when(mockClient.get(uriLocal, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      expect(() async => await syncClassroom.getClassroomsInServer(token),
          throwsA(TypeMatcher<ServerException>()));

      //verify(mockSecureStorage.read(key: "token"));
    });

    test('should return an empty list', () async {
      final uriLocal = API_URL +  'classes/';
      when(mockClient.get(uriLocal, headers: headers))
          .thenAnswer((_) async => validResponse);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final output = await syncClassroom.getClassroomsInServer(token);

      expect(output, []);
      //verify(mockSecureStorage.read(key: "token"));
      verify(mockClient.get(uriLocal, headers: headers));
    });

    test('should return a list with models', () async {
      final uriLocal = API_URL +  'classes/';
      when(mockClient.get(uriLocal, headers: headers))
          .thenAnswer((_) async => validResponseWithContent);
      //when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final output = await syncClassroom.getClassroomsInServer(token);

      expect(output, [model1, model2]);
      //verify(mockSecureStorage.read(key: "token"));
      verify(mockClient.get(uriLocal, headers: headers));
    });
  });

  group('push', () {
    test('should return a wrong response from the server', () async {
      final uriLocal = API_URL +  'classes/';
      when(mockClient.get(uriLocal, headers: headers))
          .thenAnswer((_) async => invalidResponse);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);

      final response = await syncClassroom.push();

      expect(response, UnsuccessfulResponse(message: "Error when pushing"));
    });

    test('should send a put and a post to the server', () async {
      final urlLocal = API_URL + 'classes/';
      final uriLocal = API_URL +  'classes/';

      when(mockClient.get(uriLocal, headers: headers))
          .thenAnswer((_) async => validResponsePush);
      when(mockClassroomLocalDataSourceIml
              .getClassroomsSinceLastSync(syncClassroom.lastSyncTime))
          .thenAnswer((_) async => [model1, model2]);
      when(mockSecureStorage.read(key: "token")).thenAnswer((_) async => token);
      when(mockClient.put(urlLocal,
              headers: headers, body: json.encode(model1.toJson())))
          .thenAnswer((_) async => validResponse);
      when(mockClient.post(urlLocal,
              headers: headers, body: json.encode(model2.toJson())))
          .thenAnswer((_) async => validResponse);

      final response = await syncClassroom.push();

      expect(response, SuccessfulResponse());

      verifyInOrder([
        mockClient.put(urlLocal,
            headers: headers, body: json.encode(model1.toJson())),
        mockClient.post(urlLocal,
            headers: headers, body: json.encode(model2.toJson()))
      ]);
    });
  });
}

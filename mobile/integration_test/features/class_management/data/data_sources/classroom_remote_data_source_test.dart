import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_local_data_source.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:clock/clock.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  http.Client client;
  UserRemoteDataSourceImpl userRemoteDataSourceImpl;
  MockSecureStorage mockSecureStorage;
  ClassroomLocalDataSourceImpl classroomLocalDataSourceImpl;
  ClassroomRemoteDataSourceImpl syncClassroom;
  String url;
  String token;
  final userModel = UserModel(
    localId: 1,
    firstName: "renan",
    lastName: "cunha",
    username: 'renancunhafonseca@gmail.com',
    role: Role.teacher,
    password: '0907renan',
    email: 'renancunhafonseca@gmail.com',
  );

  final school = SchoolModel(
    localId: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.public,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tClassroomModel = ClassroomModel(
    tutorId: 1,
    grade: 1,
    title: "A",
    localId: 1,
    deleted: false,
    lastUpdated: DateTime(2020).toUtc(),
    clientLastUpdated: DateTime(2020).toUtc(),
    school: 1,
  );

  final tClassroomModelPut = ClassroomModel(
      tutorId: 1,
      grade: 1,
      title: "B",
      localId: 1,
      deleted: false,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  final newClassroomServer = ClassroomModel(
      tutorId: 1,
      grade: 2,
      title: "A",
      localId: 2,
      deleted: false,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  final classroomToDelete = ClassroomModel(
      tutorId: 1,
      grade: 3,
      title: "A",
      localId: 3,
      deleted: false,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  final clientUpdateClasstoom = ClassroomModel(
      tutorId: 1,
      grade: 2,
      title: "B",
      localId: 2,
      deleted: false,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  final clientNewClasstoom = ClassroomModel(
      tutorId: 1,
      grade: 4,
      title: "A",
      localId: 4,
      deleted: false,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  final clientDeleteClasstoom = ClassroomModel(
      tutorId: 1,
      grade: 4,
      title: "A",
      localId: 4,
      deleted: true,
      lastUpdated: DateTime(2020).toUtc(),
      clientLastUpdated: DateTime(2020).toUtc(),
      school: 1);

  DateTime clientPushTime;

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
  }

  setUp(() async {
    moorRuntimeOptions.defaultSerializer = Serializer();
    client = http.Client();
    url = "http://127.0.0.1:8000/api/";
    userRemoteDataSourceImpl =
        UserRemoteDataSourceImpl(client: client, api_url: url);
    await connectDatabase();
    mockSecureStorage = MockSecureStorage();

    classroomLocalDataSourceImpl = ClassroomLocalDataSourceImpl(
      database: database,
    );

    syncClassroom = ClassroomRemoteDataSourceImpl(
      client: client,
      secureStorage: mockSecureStorage,
      classroomLocalDataSourceImpl: classroomLocalDataSourceImpl,
      api_url: url,
      clock: Clock(),
    );

    database.insertUser(userModel);
    database.insertSchool(school.toCompanion(true));
  });

  Future<void> closeDatabase(Database database) async {
    await database.close();
  }

  tearDown(() async {
    await closeDatabase(database);
  });

  group('createAccount', () {
    test('should return a correct response from the server x', () async {
      final response = await userRemoteDataSourceImpl.createUser(userModel);

      expect(response, SuccessfulResponse());
    });
  });

  group('createSchool', () {
    test('should return a correct response from the server c', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);

      token = (response as TokenResponse).token;
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "token ${token}",
      };
      final localUrl = url + "schools/";

      final schoolModel = json.encode([
        {
          "name": "A",
          "city": "C",
          "neighbourhood": "D",
          "state": "B",
          "zip_code": 0,
          "modality": 0,
          "local_id": 1,
          "deleted": 0,
          "last_update": 0,
        }
      ]);
      final postResponse =
          await client.post(localUrl, headers: headers, body: schoolModel);
      expect(postResponse.statusCode, 201);
    });
  });

  group('PostClassroom', () {
    test('should run without a exception response from the server', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      try {
        await syncClassroom.postClassroom(tClassroomModel, token);
      } on ServerException catch (e) {
        print("MESSAGE");
        print(e.message);
        throw ServerException();
      }
      equals(true);
    });
  });

  group('PutClassroom', () {
    test('should run without a exception response from the server b', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      try {
        await syncClassroom.putClassroom(tClassroomModelPut, token);
      } on ServerException catch (e) {
        print("MESSAGE");
        print(e.message);
        throw ServerException();
      }
      equals(true);
    });
  });

  group('getServerUpdated', () {
    test('should return all classrooms in server', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;

      final getResponse = await syncClassroom.getServerUpdated("", token);
      expect(getResponse.statusCode, 200);
      final body = json.decode(getResponse.body);

      expect(body[0]["local_id"], tClassroomModelPut.localId);
      expect(body[0]["grade"], tClassroomModelPut.grade);
      expect(body[0]["school"], tClassroomModelPut.school);
      expect(body[0]["deleted"], tClassroomModelPut.deleted);
      expect(body[0]["grade"], tClassroomModelPut.grade);
      final dateTimeFormat = DateTime.parse(body[0]['last_update']);
      final lastUpdatedBigger =
          dateTimeFormat.isAfter(tClassroomModelPut.lastUpdated);
      equals(lastUpdatedBigger);
    });

    test('should return all classrooms in server that were modified after 2020',
        () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      final lastSyncTime = DateTime(2020).toUtc().toString();

      final getResponse =
          await syncClassroom.getServerUpdated(lastSyncTime, token);
      expect(getResponse.statusCode, 200);
      final body = json.decode(getResponse.body);

      expect(body[0]["local_id"], tClassroomModelPut.localId);
      expect(body[0]["grade"], tClassroomModelPut.grade);
      expect(body[0]["school"], tClassroomModelPut.school);
      expect(body[0]["deleted"], tClassroomModelPut.deleted);
      expect(body[0]["grade"], tClassroomModelPut.grade);
      final dateTimeFormat = DateTime.parse(body[0]['last_update']);
      final lastUpdatedBigger =
          dateTimeFormat.isAfter(tClassroomModelPut.lastUpdated);
      equals(lastUpdatedBigger);
    });

    test('should return no classrooms in server', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      final lastSyncTime = DateTime(2050).toUtc().toString();

      final getResponse =
          await syncClassroom.getServerUpdated(lastSyncTime, token);
      expect(getResponse.statusCode, 200);
      final body = json.decode(getResponse.body);

      expect(body, []);
    });
  });

  group('pull', () {
    setUp(() async {
      await database.getClassrooms(1);
      await database.insertClassroom(tClassroomModel.toCompanion(true));
      await database.insertClassroom(classroomToDelete.toCompanion(true));
    });

    test("""should update a outdated classroom in client, create a new 
    classroom that was created in server and delete a classroom that was deleted
    in server""", () async {
      // arrange
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      when(mockSecureStorage.read(key: 'token')).thenAnswer((_) async => token);
      await syncClassroom.postClassroom(newClassroomServer, token);
      await syncClassroom.postClassroom(classroomToDelete, token);
      await syncClassroom.putClassroom(
          classroomToDelete.copyWith(deleted: true), token);

      // run
      Response pullResponse = await syncClassroom.pull();

      expect(pullResponse, SuccessfulResponse());
      final List<ClassroomModel> classroomModels =
          await classroomLocalDataSourceImpl.getClassroomsFromCache(userModel);
      expect(classroomModels.length, 2);
      expect(classroomModels[0].localId, tClassroomModelPut.localId);
      expect(classroomModels[0].grade, tClassroomModelPut.grade);
      expect(classroomModels[0].school, tClassroomModelPut.school);
      expect(classroomModels[0].deleted, tClassroomModelPut.deleted);
      expect(classroomModels[0].grade, tClassroomModelPut.grade);
      equals(classroomModels[0].clientLastUpdated.isBefore(DateTime.now()));
      equals(classroomModels[0].lastUpdated.isBefore(DateTime.now()));

      expect(classroomModels[1].localId, newClassroomServer.localId);
      expect(classroomModels[1].grade, newClassroomServer.grade);
      expect(classroomModels[1].school, newClassroomServer.school);
      expect(classroomModels[1].deleted, newClassroomServer.deleted);
      expect(classroomModels[1].grade, newClassroomServer.grade);
      equals(classroomModels[1].clientLastUpdated.isBefore(DateTime.now()));
      equals(classroomModels[1].lastUpdated.isBefore(DateTime.now()));
    });
  });

  group('push', () {
    setUp(() async {
      await database.getClassrooms(1);
      clientPushTime = DateTime.now().toUtc();
      await database.insertClassroom(newClassroomServer.toCompanion(true));
      await database.updateClassroom(
          clientUpdateClasstoom.copyWith(clientLastUpdated: clientPushTime));
      await database.insertClassroom(clientNewClasstoom
          .copyWith(clientLastUpdated: clientPushTime)
          .toCompanion(true));
    });

    test("""should update a outdated classroom in client, create a new 
    classroom that was created in server and delete a classroom that was deleted
    in server""", () async {
      // arrange
      Response response = await userRemoteDataSourceImpl.login(userModel);
      token = (response as TokenResponse).token;
      when(mockSecureStorage.read(key: 'token')).thenAnswer((_) async => token);

      // run
      syncClassroom.lastSyncTime = clientPushTime;
      Response pullResponse = await syncClassroom.push();

      expect(pullResponse, SuccessfulResponse());
      final List<ClassroomModel> classroomModels =
          await classroomLocalDataSourceImpl.getClassroomsFromCache(userModel);
      final http.Response getResponse = await syncClassroom.getServerUpdated(
          clientPushTime.toString(), token);
      Iterable objects = json.decode(getResponse.body);

      expect(objects.length, 2);
      var i = 0;
      for (var element in objects) {
        expect(classroomModels[i].localId, element['local_id']);
        expect(classroomModels[i].grade, element['grade']);
        expect(classroomModels[i].school, element['school']);
        expect(classroomModels[i].deleted, element['deleted']);
        expect(classroomModels[i].grade, element['grade']);
        equals(DateTime.parse(element['last_update']).isBefore(DateTime.now()));
        equals(DateTime.parse(element['last_update']).isAfter(clientPushTime));
        i += 1;
      }
    });
  });
}

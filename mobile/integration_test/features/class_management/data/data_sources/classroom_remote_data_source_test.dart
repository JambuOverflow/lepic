import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/features/class_management/data/data_sources/classroom_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  http.Client client;
  UserRemoteDataSourceImpl userRemoteDataSourceImpl;
  SyncClassroom syncClassroom;
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

  final schoolModelJson = json.encode({
    "name": "A",
    "city": "C",
    "neighbourhood": "D",
    "state": "B",
    "zip_code": 0,
    "modality": 0,
    "local_id": 1,
    "deleted": 0,
    "last_update": 0,
    "creator": 1,
  });

  setUp(() {
    moorRuntimeOptions.defaultSerializer = Serializer();
    client = http.Client();
    url = "http://127.0.0.1:8000/api/";
    userRemoteDataSourceImpl =
        UserRemoteDataSourceImpl(client: client, api_url: url);
  });

  group('createAccount', () {
    test('should return a correct response from the server', () async {
      final response = await userRemoteDataSourceImpl.createUser(userModel);

      expect(response, SuccessfulResponse());
    });
  });

  group('createSchool', () {
    test('should return a correct response from the server', () async {
      Response response = await userRemoteDataSourceImpl.login(userModel);

      token = (response as TokenResponse).token;
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "token ${token}",
      };
      final localUrl = url + "schools/";
      print(schoolModelJson);
      final postResponse = await client
          .post(localUrl, headers: headers, body: [schoolModelJson]);
      print("RESPONSE BODY");
      print(postResponse.body);
      expect(postResponse.statusCode, 200);
    });
  });
}

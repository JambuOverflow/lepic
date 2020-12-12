import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  moorRuntimeOptions.defaultSerializer = UserSerializer();

  final tUserModel = UserModel(
    localId: 1,
    firstName: 'ab',
    lastName: 'c',
    email: 'abc@g.com',
    role: Role.teacher,
    password: 'x1y2',
  );

  final tUserEntity = User(
      id: 1,
      firstName: 'ab',
      lastName: 'c',
      email: 'abc@g.com',
      role: Role.teacher,
      password: 'x1y2');

  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('user'));

      final result = UserModel.fromJson(jsonMap);

      expect(result, tUserModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map with proper data', () async {
      final result = tUserModel.toJson();

      final expectedMap = {
        "local_id": 1,
        "first_name": "ab",
        "last_name": "c",
        "email": "abc@g.com",
        "role": 0,
        "password": "x1y2"
      };

      expect(result, expectedMap);
    });
  });

  group('entityToModel', () {
    test('should return a Model map with proper data', () async {
      final result = userEntityToModel(tUserEntity);

      expect(result, tUserModel);
    });
  });
}

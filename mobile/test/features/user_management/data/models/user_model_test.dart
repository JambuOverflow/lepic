import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    firstName: 'ab',
    lastName: 'c',
    email: 'abc@g.com',
    role: Role.teacher,
    password: 'x1y2',
  );

  test('should be a subclass of User entity', () async {
    expect(tUserModel, isA<User>());
  });

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
        "first_name": "ab",
        "last_name": "c",
        "email": "abc@g.com",
        "role": 0,
        "password": "x1y2"
      };

      expect(result, expectedMap);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tUser = UserModel(
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tClassroomModel =
      ClassroomModel(tutor: tUser, grade: 1, name: 'A', id: 1);

  test('should be a subclass of Classroom entity', () async {
    expect(tClassroomModel, isA<Classroom>());
  });

  group('fromJson', () {
    test('should return a valid ClassroomModel', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('classroom'));

      final result = ClassroomModel.fromJson(jsonMap);

      expect(result, tClassroomModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map with proper data', () async {
      final result = tClassroomModel.toJson();

      final expectedMap = {
        "tutor": {
          "first_name": "v",
          "last_name": "c",
          "email": "v@g.com",
          "role": 0,
          "password": "123"
        },
        "grade": 1,
        "name": "A",
        "id": 1
      };

      expect(result, expectedMap);
    });
  });
}

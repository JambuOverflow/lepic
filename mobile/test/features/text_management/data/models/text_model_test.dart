import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/data/database.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tTextModel = TextModel(
    title: '1',
    localId: 2,
    body: "A",
    studentId: 3,
    tutorId: 1,
    dateCreated: null,
  );

  group("from json", () {
    test("should return a valid Text model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('text'));

      final result = TextModel.fromJson(jsonMap);

      expect(result, tTextModel);
    });
  });

  group('toJson', () {
    test('should return a Text JSON map with proper data', () async {
      final result = tTextModel.toJson();

      final expectedMap = {
        "local_id": 2,
        "title": '1',
        "body": "A",
        "student_id": 3,
        "tutor_id": 1,
        "date_created": null
      };

      expect(result, expectedMap);
    });
  });
}

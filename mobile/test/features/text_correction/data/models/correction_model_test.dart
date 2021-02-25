import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:moor/moor.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  moorRuntimeOptions.defaultSerializer = Serializer();

  final tCorrectionModel = CorrectionModel(
    localId: 1,
    textId: 1,
    studentId: 1,
  );

  group("from json", () {
    test("should return a valid Correction model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('correction'));

      final result = CorrectionModel.fromJson(jsonMap);

      expect(result, tCorrectionModel);
    });
  });

  group('toJson', () {
    test('should return a Correction JSON map with proper data', () async {
      final result = tCorrectionModel.toJson();

      final expectedMap = {
        "local_id": 1,
        "text_id": 1,
        "student_id": 1,
      };

      expect(result, expectedMap);
    });
  });
}

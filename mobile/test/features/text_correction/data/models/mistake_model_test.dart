import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/serializer.dart';
import 'package:moor/moor.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  moorRuntimeOptions.defaultSerializer = Serializer();

  final tMistakeModel = MistakeModel(
    localId: 1,
    studentId: 1,
    textId: 1,
    commentary: ";)",
    wordIndex: 1,
  );

  group("from json", () {
    test("should return a valid Correction model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('mistake'));

      final result = MistakeModel.fromJson(jsonMap);

      expect(result, tMistakeModel);
    });
  });

  group('toJson', () {
    test('should return a Correction JSON map with proper data', () async {
      final result = tMistakeModel.toJson();

      final expectedMap = {
        "local_id": 1,
        "word_index": 1,
        "commentary": ";)",
        "text_id": 1,
        "student_id": 1,
      };

      expect(result, expectedMap);
    });
  });
}

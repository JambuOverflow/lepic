import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudioModel = AudioModel(
    title: '1',
    localId: 2,
    audioData: audio_data,
    studentId: 1,
    textId: 1,
  );

  group("from json", () {
    test("should return a valid Audio model", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('audio'));

      final result = AudioModel.fromJson(jsonMap);

      expect(result.localId, 2);
      expect(result.title, '1');
      equals(listEquals(result.audioData, [1, 2]));
      expect(result.textId, 1);
      expect(result.studentId, 1);
    });
  });

  group('toJson', () {
    test('should return a Audio JSON map with proper data', () async {
      final result = tAudioModel.toJson();

      final expectedMap = {
        "local_id": 2,
        "title": '1',
        "audio_data": [1, 2],
        "text_id": 1,
        "student_id": 1,
      };

      expect(result['local_id'], 2);
      expect(result['title'], '1');
      equals(listEquals(result['audio_data'], [1, 2]));
      expect(result['text_id'], 1);
      expect(result['student_id'], 1);
    });
  });
}

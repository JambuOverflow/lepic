import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/audio_entity_model_converter.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';


void main() {
  AudioEntityModelConverter audioEntityModelConverter;

  setUp(() {

    audioEntityModelConverter = AudioEntityModelConverter();
  });

  Uint8List audio_data;

  final tAudioModel = AudioModel(
    title: '1',
    localId: 2,
    audioData: audio_data,
    studentId: 1,
    textId: 1,
  );

  final tAudioEntity = AudioEntity(
    title: '1',
    localId: 2,
    data: audio_data,
    studentId: 1,
    textId: 1,
  );

  group('modelToEntity', () {
    test('should return a Audio entity with proper data', ()  {
      final result = audioEntityModelConverter.modelToEntity(tAudioModel);

      expect(result, tAudioEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', ()  {
      final result = audioEntityModelConverter.entityToModel(tAudioEntity);

      expect(result, tAudioModel);
    });
  });
}

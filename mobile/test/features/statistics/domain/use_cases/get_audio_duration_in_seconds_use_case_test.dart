import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_audio_duration_in_seconds_use_case.dart';


void main() {
  GetAudioDurationInMinutesUseCase useCase;

  setUp(() {
    useCase = GetAudioDurationInMinutesUseCase();
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
    localId: 1,
  );

  test('should return a correct response when updating a audio', () async {

    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(2));
  });
}

import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/update_audio_use_case.dart';
import 'package:mockito/mockito.dart';

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  UpdateAudioUseCase useCase;
  MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    useCase = UpdateAudioUseCase(repository: mockAudioRepository);
  });

  Uint8List audio_data;

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
  );

  test('should return a correct response when updating a audio', () async {
    when(mockAudioRepository.updateAudio(tAudio))
        .thenAnswer((_) async => Right(tAudio));

    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(tAudio));
    verify(mockAudioRepository.updateAudio(tAudio));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}

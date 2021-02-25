import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/delete_audio_use_case.dart';
import 'package:mockito/mockito.dart';

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  DeleteAudioUseCase useCase;
  MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    useCase = DeleteAudioUseCase(repository: mockAudioRepository);
  });

  Uint8List audio_data;

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
  );
  test('should return nothing when deleting a audio', () async {

    await useCase(AudioParams(audio: tAudio));

    verify(mockAudioRepository.deleteAudio(tAudio));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}

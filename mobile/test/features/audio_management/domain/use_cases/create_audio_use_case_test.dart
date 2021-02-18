import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/create_audio_use_case.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  CreateAudioUseCase useCase;
  MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    useCase = CreateAudioUseCase(repository: mockAudioRepository);
  });
  Uint8List audio_data;

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
  );

  test('should return a correct response when creating a audio', () async {
    when(mockAudioRepository.createAudio(tAudio))
        .thenAnswer((_) async => Right(tAudio));

    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(tAudio));
    verify(mockAudioRepository.createAudio(tAudio));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}

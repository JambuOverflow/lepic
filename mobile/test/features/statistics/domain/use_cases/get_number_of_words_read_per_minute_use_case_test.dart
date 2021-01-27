import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_audio_duration_in_seconds_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetTextUseCase extends Mock implements GetTextUseCase {}

class MockGetAudioDurationInMinutesUseCase extends Mock
    implements GetAudioDurationInMinutesUseCase {}

void main() {
  GetNumberOfWordsReadPerMinuteUseCase useCase;
  MockGetTextUseCase mockGetTextUseCase;
  MockGetAudioDurationInMinutesUseCase mockGetAudioDurationInMinutesUseCase;

  setUp(() {
    mockGetTextUseCase = MockGetTextUseCase();
    mockGetAudioDurationInMinutesUseCase =
        MockGetAudioDurationInMinutesUseCase();
    useCase = GetNumberOfWordsReadPerMinuteUseCase(
      getTextUseCase: mockGetTextUseCase,
      getAudioDurationInMinutesUseCase: mockGetAudioDurationInMinutesUseCase,
    );
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
    localId: 1,
  );

  final tText = MyText(
    title: "null",
    body: "ola amigos",
    classId: 1,
    localId: 1,
  );

  test('should the number of words per minut', () async {
    when(mockGetAudioDurationInMinutesUseCase.call(AudioParams(audio: tAudio)))
        .thenAnswer((_) async => Right(2));
    when(mockGetTextUseCase.call(1)).thenAnswer((_) async => Right(tText));
    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(1));
  });
}

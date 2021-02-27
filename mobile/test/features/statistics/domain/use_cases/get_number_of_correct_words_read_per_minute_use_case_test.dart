import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetTextUseCase extends Mock implements GetTextUseCase {}

class MockGetAudioFromId extends Mock implements GetAudioFromIdUseCase {}

void main() {
  GetNumberOfCorrectWordsReadPerMinuteUseCase useCase;
  MockGetTextUseCase mockGetTextUseCase;
  MockGetAudioFromId mockGetAudioFromId;

  setUp(() {
    mockGetTextUseCase = MockGetTextUseCase();
    mockGetAudioFromId = MockGetAudioFromId();
    useCase = GetNumberOfCorrectWordsReadPerMinuteUseCase(
        getTextUseCase: mockGetTextUseCase,
        getAudioFromIdUseCase: mockGetAudioFromId);
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
    audioDuration: Duration(seconds: 120)
  );

  final tText = MyText(
    title: "null",
    body: "ola amigos",
    studentId: 1,
    localId: 1,
  );

  final mistakes = [Mistake(wordIndex: 0, commentary: "ett")];

  final tCorrection = Correction(textId: 1, studentId: 1, mistakes: mistakes);

  test('should return the number of correct words per minute', () async {
    final CorrectionIdParams params =
        CorrectionIdParams(textId: 1, studentId: 1);
    when(mockGetTextUseCase(1)).thenAnswer((_) async => Right(tText));
    when(mockGetAudioFromId(params)).thenAnswer((_) async => Right(tAudio));
    final result = await useCase(CorrectionParams(correction: tCorrection));

    expect(result, Right(0.5));
  });
}

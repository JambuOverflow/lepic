import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetTextUseCase extends Mock implements GetTextUseCase {}



class MockGetCorrectionFromIdUseCase extends Mock
    implements GetCorrectionFromIdUseCase {}

void main() {
  GetNumberOfCorrectWordsReadPerMinuteUseCase useCase;
  MockGetTextUseCase mockGetTextUseCase;
  MockGetCorrectionFromIdUseCase mockGetCorrectionFromIdUseCase;

  setUp(() {
    mockGetTextUseCase = MockGetTextUseCase();
    mockGetCorrectionFromIdUseCase = MockGetCorrectionFromIdUseCase();
    useCase = GetNumberOfCorrectWordsReadPerMinuteUseCase(
        getTextUseCase: mockGetTextUseCase,
        getCorrectionFromIdUseCase: mockGetCorrectionFromIdUseCase);
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

  final mistakes = [Mistake(wordIndex: 0, commentary: "ett")];

  final tCorrection = Correction(textId: 1, studentId: 1, mistakes: mistakes);

  test('should return the number of correct words per minute', () async {

    when(mockGetTextUseCase.call(1)).thenAnswer((_) async => Right(tText));
    when(mockGetCorrectionFromIdUseCase
            .call(CorrectionIdParams(textId: 1, studentId: 1)))
        .thenAnswer((_) async => Right(tCorrection));
    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(0.5));
  });
}

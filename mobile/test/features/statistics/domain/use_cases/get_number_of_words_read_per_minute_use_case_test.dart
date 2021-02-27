import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetTextUseCase extends Mock implements GetTextUseCase {}

void main() {
  GetNumberOfWordsReadPerMinuteUseCase useCase;
  MockGetTextUseCase mockGetTextUseCase;

  setUp(() {
    mockGetTextUseCase = MockGetTextUseCase();

    useCase = GetNumberOfWordsReadPerMinuteUseCase(
      getTextUseCase: mockGetTextUseCase,
    );
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
    audioDuration: Duration(seconds: 240)
  );

  final tText = MyText(
    title: "null",
    body: "ola amigos",
    studentId: 1,
    localId: 1,
  );

  test('should the number of words per minut', () async {
    when(mockGetTextUseCase.call(1)).thenAnswer((_) async => Right(tText));
    final result = await useCase(AudioParams(audio: tAudio));

    expect(result, Right(0.5));
  });
}

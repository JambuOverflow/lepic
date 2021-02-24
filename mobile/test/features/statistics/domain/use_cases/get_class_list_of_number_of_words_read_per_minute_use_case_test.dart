import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_class_use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetNumberOfWordsReadPerMinuteUseCase extends Mock
    implements GetNumberOfWordsReadPerMinuteUseCase {}

class MockGetAllAudiosFromClassUseCase extends Mock
    implements GetAllAudiosFromClassUseCase {}

void main() {
  GetClassListOfNumberOfWordsReadPerMinuteUseCase useCase;
  MockGetAllAudiosFromClassUseCase mockGetAllAudiosFromClassUseCase;
  MockGetNumberOfWordsReadPerMinuteUseCase
      mockGetNumberOfWordsReadPerMinuteUseCase;

  setUp(() {
    mockGetNumberOfWordsReadPerMinuteUseCase =
        MockGetNumberOfWordsReadPerMinuteUseCase();
    mockGetAllAudiosFromClassUseCase = MockGetAllAudiosFromClassUseCase();

    useCase = GetClassListOfNumberOfWordsReadPerMinuteUseCase(
      getAllAudiosFromClassUseCase: mockGetAllAudiosFromClassUseCase,
      getNumberOfWordsReadPerMinuteUseCase:
          mockGetNumberOfWordsReadPerMinuteUseCase,
    );
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tAudio1 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
    localId: 1,
  );

  final tAudio2 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
    localId: 2,
  );

  final List<AudioEntity> audios = [tAudio1, tAudio2];

  final AudioParams audioParams1 = AudioParams(audio: tAudio1);
  final AudioParams audioParams2 = AudioParams(audio: tAudio2);

  final Classroom classroom = Classroom(grade: 1, name: "", id: 1);
  final ClassroomParams classroomParams = ClassroomParams(classroom: classroom);

  final double stat1 = 10;
  final double stat2 = 5;

  test('should get a list of the number of words per minute', () async {
    when(mockGetAllAudiosFromClassUseCase.call(classroomParams))
        .thenAnswer((_) async => Right(audios));
    when(mockGetNumberOfWordsReadPerMinuteUseCase.call(audioParams1))
        .thenAnswer((_) async => Right(10));
    when(mockGetNumberOfWordsReadPerMinuteUseCase.call(audioParams2))
        .thenAnswer((_) async => Right(5));

    final result = await useCase(classroomParams);
    result.fold((l) {
      expect(true, false);
    }, (r) {
      expect(true, listEquals([10, 5], r));
    });
  });
}

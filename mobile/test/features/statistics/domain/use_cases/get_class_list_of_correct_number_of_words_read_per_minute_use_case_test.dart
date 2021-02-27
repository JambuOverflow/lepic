import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_class_use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_class_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetNumberOfCorrectWordsReadPerMinuteUseCase extends Mock
    implements GetNumberOfCorrectWordsReadPerMinuteUseCase {}

class MockGetAllCorrectionsFromClassUseCase extends Mock
    implements GetAllCorrectionsFromClassUseCase {}

void main() {
  GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase useCase;
  MockGetAllCorrectionsFromClassUseCase mockGetAllCorrectionsFromClassUseCase;
  MockGetNumberOfCorrectWordsReadPerMinuteUseCase
      mockGetNumberOfCorrectWordsReadPerMinuteUseCase;

  setUp(() {
    mockGetNumberOfCorrectWordsReadPerMinuteUseCase = MockGetNumberOfCorrectWordsReadPerMinuteUseCase();
    mockGetAllCorrectionsFromClassUseCase = MockGetAllCorrectionsFromClassUseCase();

    useCase = GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(
      getAllCorrectionsFromClassUseCase: mockGetAllCorrectionsFromClassUseCase,
      getNumberOfCorrectWordsReadPerMinuteUseCase:
          mockGetNumberOfCorrectWordsReadPerMinuteUseCase,
    );
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tCorrection1 = Correction(
    textId: 1,
    studentId: 1,
    localId: 1,
    mistakes: [],
  );

  final tCorrection2 = Correction(
    textId: 1,
    studentId: 1,
    localId: 2,
    mistakes: [],
  );

  final List<Correction> corrections = [tCorrection1, tCorrection2];

  final CorrectionParams audioParams1 = CorrectionParams(correction: tCorrection1);
  final CorrectionParams audioParams2 = CorrectionParams(correction: tCorrection2);

  final Classroom classroom = Classroom(grade: 1, name: "", id: 1);
  final ClassroomParams classroomParams = ClassroomParams(classroom: classroom);

  final double stat1 = 10;
  final double stat2 = 5;

  test('should get a list of the number of words per minute', () async {
    when(mockGetAllCorrectionsFromClassUseCase.call(classroomParams))
        .thenAnswer((_) async => Right(corrections));
    when(mockGetNumberOfCorrectWordsReadPerMinuteUseCase.call(audioParams1))
        .thenAnswer((_) async => Right(10));
    when(mockGetNumberOfCorrectWordsReadPerMinuteUseCase.call(audioParams2))
        .thenAnswer((_) async => Right(5));

    final result = await useCase(classroomParams);
    result.fold((l) {
      expect(false, true);
    }, (r) {
      expect(listEquals([5, 5], r), true);
    });
  });
}

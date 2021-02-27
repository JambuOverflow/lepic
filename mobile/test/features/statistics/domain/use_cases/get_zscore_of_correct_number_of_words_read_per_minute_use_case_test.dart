import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classroom_from_id_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_zscore_of_correct_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_zscore_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_student_from_id_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mockito/mockito.dart';

class MockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase extends Mock
    implements GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase {}

class MockGetClassroomFromId extends Mock implements GetClassroomFromId {}

class MockGetStudentFromId extends Mock implements GetStudentFromId {}

class MockGetNumberOfCorrectWordsReadPerMinuteUseCase extends Mock
    implements GetNumberOfCorrectWordsReadPerMinuteUseCase {}

void main() {
  GetZscoreOfCorrectNumberOfWordsReadPerMinuteUseCase useCase;
  MockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase
      mockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase;
  MockGetClassroomFromId mockGetClassroomFromId;
  MockGetStudentFromId mockGetStudentFromId;
  MockGetNumberOfCorrectWordsReadPerMinuteUseCase
      mockGetNumberOfCorrectWordsReadPerMinuteUseCase;

  setUp(() {
    mockGetNumberOfCorrectWordsReadPerMinuteUseCase =
        MockGetNumberOfCorrectWordsReadPerMinuteUseCase();
    mockGetStudentFromId = MockGetStudentFromId();
    mockGetClassroomFromId = MockGetClassroomFromId();
    mockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase =
        MockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase();

    useCase = GetZscoreOfCorrectNumberOfWordsReadPerMinuteUseCase(
        getNumberOfCorrectWordsReadPerMinuteUseCase:
            mockGetNumberOfCorrectWordsReadPerMinuteUseCase,
        getStudentFromId: mockGetStudentFromId,
        getClassroomFromId: mockGetClassroomFromId,
        getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase:
            mockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase);
  });

  Uint8List audio_data = Uint8List.fromList([1, 2]);

  final tCorrection1 = Correction(
    textId: 1,
    studentId: 1,
    localId: 1,
    mistakes: []
  );


  final tStudent = Student(
    firstName: "",
    lastName: "",
    classroomId: 1,
    id: 1,
  );

  final tClassroom = Classroom(grade: 1, name: "", id: 1);

  final List<Correction> corrections = [tCorrection1];

  final CorrectionParams correctionParams = CorrectionParams(correction: tCorrection1);

  final Classroom classroom = Classroom(grade: 1, name: "", id: 1);
  final ClassroomParams classroomParams = ClassroomParams(classroom: classroom);

  final double stat1 = 10;
  final double stat2 = 5;

  test('should get a list of the number of words per minute', () async {
    when(mockGetStudentFromId(1)).thenAnswer((_) async => Right(tStudent));
    when(mockGetClassroomFromId(1)).thenAnswer((_) async => Right(tClassroom));
    when(mockGetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(classroomParams))
        .thenAnswer((_) async => Right([10.0, 1.0]));
    when(mockGetNumberOfCorrectWordsReadPerMinuteUseCase(correctionParams))
        .thenAnswer((_) async => Right(1.0));

    final result = await useCase(correctionParams);
    expect(result, Right(ReadingStatus.deficitAlert));
  });
}

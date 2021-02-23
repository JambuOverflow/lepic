import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockCorrectionRepository extends Mock implements CorrectionRepository {}

void main() {
  GetCorrectionUseCase useCase;
  MockCorrectionRepository mockCorrectionRepository;

  setUp(() {
    mockCorrectionRepository = MockCorrectionRepository();
    useCase = GetCorrectionUseCase(repository: mockCorrectionRepository);
  });

  final List<Mistake> mistakes = [
    Mistake(localId: 1, wordIndex: 0, commentary: "ola")
  ];

  final tCorrection1 = Correction(
    audioId: 1,
    mistakes: mistakes,
  );

  final text = MyText(
    title: "A",
    body: "A",
    localId: 1,
    studentId: 1,
  );

  final student = Student(
    firstName: "A",
    lastName: "B",
    classroomId: 1,
    id: 1,
  );

  final audio =
      AudioEntity(title: "", textId: 1, studentId: 1, audioData: null);

  test('should return list of corrections', () async {
    when(mockCorrectionRepository.getCorrection(audio))
        .thenAnswer((_) async => Right(tCorrection1));

    final result =
        await useCase(AudioParams(audio: audio));

    expect(result, Right(tCorrection1));
    verify(
        mockCorrectionRepository.getCorrection(audio));
    verifyNoMoreInteractions(mockCorrectionRepository);
  });
}

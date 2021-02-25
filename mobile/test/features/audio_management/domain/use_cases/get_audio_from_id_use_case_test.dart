import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  GetAudioFromIdUseCase useCase;
  MockAudioRepository mockAudioRepository;

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    useCase = GetAudioFromIdUseCase(repository: mockAudioRepository);
  });

  Uint8List audio_data;

  final tAudio = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
  );

  final tStudent = Student(
    firstName: "",
    lastName: "",
    classroomId: 1,
    id: 1,
  );

  final tText = MyText(
    title: "",
    body: "",
    studentId: 1,
    localId: 1,
  );

  test('should correctly return an audo', () async {
    when(mockAudioRepository.getAudioFromId(studentId: 1, textId: 1))
        .thenAnswer((_) async => Right(tAudio));

    final CorrectionIdParams params = CorrectionIdParams(
      textId: 1,
      studentId: 1,
    );
    final result = await useCase(params);

    expect(result, Right(tAudio));
    verify(mockAudioRepository.getAudioFromId(studentId: 1, textId: 1));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}

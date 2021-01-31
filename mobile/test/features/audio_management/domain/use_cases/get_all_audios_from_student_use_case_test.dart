import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_student_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  GetAllAudiosFromStudent useCase;
  MockAudioRepository mockAudioRepository;

  // Returns the sum of a and b
  int exampleFunction(
    int a,
    int b,
  ) {
    return a + b;
  }

  setUp(() {
    mockAudioRepository = MockAudioRepository();
    useCase = GetAllAudiosFromStudent(repository: mockAudioRepository);
  });

  Uint8List audio_data;

  final tAudio1 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    audioData: audio_data,
    localId: 1,
  );
  final tAudio2 = AudioEntity(
    title: "a",
    textId: 2,
    studentId: 1,
    audioData: audio_data,
    localId: 2,
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

  final List<AudioEntity> tAudios = [tAudio1, tAudio2];

  test('should correctly return the audio list', () async {
    when(mockAudioRepository.getAllAudiosFromStudent(tStudent))
        .thenAnswer((_) async => Right(tAudios));

    final StudentParams params = StudentParams(student: tStudent);
    final result = await useCase(params);

    expect(result, Right(tAudios));
    verify(mockAudioRepository.getAllAudiosFromStudent(tStudent));
    verifyNoMoreInteractions(mockAudioRepository);
  });
}

import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_class_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_student_use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mockito/mockito.dart';

class MockGetAllAudiosFromStudentUseCase extends Mock
    implements GetAllAudiosFromStudentUseCase {}

class MockGetStudents extends Mock implements GetStudents {}

void main() {
  GetAllAudiosFromClassUseCase useCase;
  MockGetAllAudiosFromStudentUseCase mockGetAllAudiosFromStudentUseCase;
  MockGetStudents mockGetStudents;

  setUp(() {
    mockGetAllAudiosFromStudentUseCase = MockGetAllAudiosFromStudentUseCase();
    mockGetStudents = MockGetStudents();

    useCase = GetAllAudiosFromClassUseCase(
      getAllAudiosFromStudentUseCase: mockGetAllAudiosFromStudentUseCase,
      getStudents: mockGetStudents,
    );
  });

  Uint8List audio_data;

  final tAudio1 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 1,
  );
  final tAudio2 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 1,
    data: audio_data,
    localId: 2,
  );

  final tAudio3 = AudioEntity(
    title: "a",
    textId: 1,
    studentId: 2,
    data: audio_data,
    localId: 3,
  );

  final tStudent1 = Student(
    firstName: "",
    lastName: "",
    classroomId: 1,
    id: 1,
  );

  final tStudent2 = Student(
    firstName: "",
    lastName: "",
    classroomId: 1,
    id: 2,
  );

  final tClassroom = Classroom(grade: 1, name: "", id: 1);

  final List<AudioEntity> tAudiosStudent1 = [tAudio1, tAudio2];
  final List<AudioEntity> tAudiosStudent2 = [tAudio3];
  final List<AudioEntity> tAllAudios = tAudiosStudent1 + tAudiosStudent1;

  final List<Student> students = [tStudent1, tStudent2];

  final StudentParams studentParams1 = StudentParams(student: tStudent1);
  final StudentParams studentParams2 = StudentParams(student: tStudent2);

  final ClassroomParams classroomParams =
      ClassroomParams(classroom: tClassroom);

  test('should correctly return the audio list', () async {
    when(mockGetStudents(classroomParams))
        .thenAnswer((_) async => Right(students));
    when(mockGetAllAudiosFromStudentUseCase.call(studentParams2))
        .thenAnswer((_) async => Right(tAudiosStudent2));
    when(mockGetAllAudiosFromStudentUseCase.call(studentParams1))
        .thenAnswer((_) async => Right(tAudiosStudent1));
    
    final result = await useCase(classroomParams);
    List<AudioEntity> audiosList;
    result.fold((l) {
      expect(true, false);
    }, (r) {
      audiosList = r;
    });
    expect(true, listEquals(audiosList, tAllAudios));
    verifyInOrder([
      mockGetStudents(classroomParams),
      mockGetAllAudiosFromStudentUseCase(studentParams1),
      mockGetAllAudiosFromStudentUseCase(studentParams2),
    ]);
    verifyNoMoreInteractions(mockGetStudents);
    verifyNoMoreInteractions(mockGetAllAudiosFromStudentUseCase);
  });
}

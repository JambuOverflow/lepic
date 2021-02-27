import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_class_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_student_use_case.dart';
import 'package:mockito/mockito.dart';

class MockGetAllCorrectionsOfStudentUseCase extends Mock
    implements GetAllCorrectionsOfStudentUseCase {}

class MockGetStudents extends Mock implements GetStudents {}

void main() {
  GetAllCorrectionsFromClassUseCase useCase;
  MockGetAllCorrectionsOfStudentUseCase mockGetAllCorrectionsOfStudentUseCase;
  MockGetStudents mockGetStudents;

  setUp(() {
    mockGetAllCorrectionsOfStudentUseCase = MockGetAllCorrectionsOfStudentUseCase();
    mockGetStudents = MockGetStudents();

    useCase =   GetAllCorrectionsFromClassUseCase(
      getAllCorrectionsFromStudentUseCase: mockGetAllCorrectionsOfStudentUseCase,
      getStudents: mockGetStudents,
    );
  });

  Uint8List correction_data;

  final tCorrection1 = Correction(
    textId: 1,
    studentId: 1,
    mistakes: [],
    localId: 1,
  );


  final tCorrection2 = Correction(
     textId: 1,
    studentId: 1,
    mistakes: [],
    localId: 2,
  );

  final tCorrection3 = Correction(
    textId: 1,
    studentId: 2,
    mistakes: [],
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

  final List<Correction> tCorrectionsStudent1 = [tCorrection1, tCorrection2];
  final List<Correction> tCorrectionsStudent2 = [tCorrection3];
  final List<Correction> tAllCorrections = tCorrectionsStudent1 + tCorrectionsStudent1;

  final List<Student> students = [tStudent1, tStudent2];

  final StudentParams studentParams1 = StudentParams(student: tStudent1);
  final StudentParams studentParams2 = StudentParams(student: tStudent2);

  final ClassroomParams classroomParams =
      ClassroomParams(classroom: tClassroom);

  test('should correctly return the correction list', () async {
    when(mockGetStudents(classroomParams))
        .thenAnswer((_) async => Right(students));
    when(mockGetAllCorrectionsOfStudentUseCase.call(studentParams2))
        .thenAnswer((_) async => Right(tCorrectionsStudent2));
    when(mockGetAllCorrectionsOfStudentUseCase.call(studentParams1))
        .thenAnswer((_) async => Right(tCorrectionsStudent1));
    
    final result = await useCase(classroomParams);
    List<Correction> correctionsList;
    result.fold((l) {
      expect(false, true);
    }, (r) {
      correctionsList = r;
    });
    expect(true, listEquals(correctionsList, tAllCorrections));
    verifyInOrder([
      mockGetStudents(classroomParams),
      mockGetAllCorrectionsOfStudentUseCase(studentParams1),
      mockGetAllCorrectionsOfStudentUseCase(studentParams2),
    ]);
    verifyNoMoreInteractions(mockGetStudents);
    verifyNoMoreInteractions(mockGetAllCorrectionsOfStudentUseCase);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_all_corrections_of_student_use_case.dart';

class GetAllCorrectionsFromClassUseCase
    implements UseCase<List<Correction>, ClassroomParams> {
  final GetAllCorrectionsOfStudentUseCase getAllCorrectionsFromStudentUseCase;
  final GetStudents getStudents;

  GetAllCorrectionsFromClassUseCase({
    @required this.getAllCorrectionsFromStudentUseCase,
    @required this.getStudents,
  });

  @override
  Future<Either<Failure, List<Correction>>> call(
    ClassroomParams params,
  ) async {
    try {
      List<Student> students = await _getStudents(params);

      List<Correction> corrections = [];
      for (var i = 0; i < students.length; i++) {
        final Student student = students[i];
        final List<Correction> localCorrections = await _getLocalCorrections(student);
        corrections = corrections + localCorrections;
      }
      return Right(corrections);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<List<Correction>> _getLocalCorrections(Student student) async {
    final StudentParams studentParams = StudentParams(student: student);
    List<Correction> localCorrections;

    final correctionOutput = await getAllCorrectionsFromStudentUseCase(studentParams);
    correctionOutput.fold((l) {
      throw Exception();
    }, (r) {
      localCorrections = r;
    });
    return localCorrections;
  }

  Future<List<Student>> _getStudents(ClassroomParams params) async {
    final getStudentsOutput = await getStudents(params);
    List<Student> students;
    getStudentsOutput.fold((l) {
      throw Exception();
    }, (r) {
      students = r;
    });
    return students;
  }
}

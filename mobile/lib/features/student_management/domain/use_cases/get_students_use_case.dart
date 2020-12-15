import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';

class GetStudents implements UseCase<List<Student>, ClassroomParams> {
  final StudentRepository repository;

  GetStudents({@required this.repository});

  @override
  Future<Either<Failure, List<Student>>> call(ClassroomParams params) =>
      repository.getStudents(params.classroom);
}

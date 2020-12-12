import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';

class UpdateStudent implements UseCase<Student, StudentParams> {
  final StudentRepository repository;

  UpdateStudent({@required this.repository});

  @override
  Future<Either<Failure, Student>> call(StudentParams params) =>
      repository.updateStudent(params.student);
}

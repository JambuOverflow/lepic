import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';

class GetStudentFromId implements UseCase<Student, int> {
  final StudentRepository repository;

  GetStudentFromId({@required this.repository});

  @override
  Future<Either<Failure, Student>> call(int params) =>
      repository.getStudentFromId(params);
}

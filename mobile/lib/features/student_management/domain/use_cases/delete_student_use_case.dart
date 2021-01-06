import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/student_management/domain/repositories/student_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';

class DeleteStudent implements UseCase<void, StudentParams> {
  final StudentRepository repository;

  DeleteStudent({@required this.repository});

  @override
  Future<Either<Failure, void>> call(StudentParams params) =>
      repository.deleteStudent(params.student);
}

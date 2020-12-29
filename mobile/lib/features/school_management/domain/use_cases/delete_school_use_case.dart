import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/school_repository.dart';
import 'school_params.dart';

class DeleteSchool implements UseCase<void, SchoolParams> {
  final SchoolRepository repository;

  DeleteSchool({@required this.repository});

  @override
  Future<Either<Failure, void>> call(SchoolParams params) =>
      repository.deleteSchool(params.school);
}

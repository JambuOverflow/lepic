import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/school_params.dart';

class CreateSchool implements UseCase<School, SchoolParams> {
  final SchoolRepository repository;

  CreateSchool({@required this.repository});

  @override
  Future<Either<Failure, School>> call(SchoolParams params) =>
      repository.createSchool(params.school);
}

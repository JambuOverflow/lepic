import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/school_management/domain/use_cases/school_params.dart';

class UpdateSchool implements UseCase<School, SchoolParams> {
  final SchoolRepository repository;

  UpdateSchool({@required this.repository});

  @override
  Future<Either<Failure, School>> call(SchoolParams params) =>
      repository.updateSchool(params.school);
}

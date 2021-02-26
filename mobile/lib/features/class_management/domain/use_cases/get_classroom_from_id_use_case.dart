import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';

class GetClassroomFromId implements UseCase<Classroom, int> {
  final ClassroomRepository repository;

  GetClassroomFromId({@required this.repository});

  @override
  Future<Either<Failure, Classroom>> call(params) =>
      repository.getClassroomFromId(params);
}

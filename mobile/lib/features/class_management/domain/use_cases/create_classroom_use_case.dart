import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';

class CreateClassroom implements UseCase<Classroom, ClassroomParams> {
  final ClassroomRepository repository;

  CreateClassroom({@required this.repository});

  @override
  Future<Either<Failure, Classroom>> call(ClassroomParams params) =>
      repository.createClassroom(params.classroom);
}

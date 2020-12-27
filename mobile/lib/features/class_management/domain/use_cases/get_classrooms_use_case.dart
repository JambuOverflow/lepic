import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/user_management/domain/use_cases/user_params.dart';

class GetClassrooms implements UseCase<List<Classroom>, UserParams> {
  final ClassroomRepository repository;

  GetClassrooms({@required this.repository});

  @override
  Future<Either<Failure, List<Classroom>>> call(UserParams params) =>
      repository.getClassrooms(params.user);
}

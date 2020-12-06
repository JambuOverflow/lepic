import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/repositories/classroom_repository.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:http/http.dart' as http;

class UpdateClassroom implements UseCase<http.Response, ClassroomParams> {
  final ClassroomRepository repository;

  UpdateClassroom({@required this.repository});

  @override
  Future<Either<Failure, http.Response>> call(ClassroomParams params) =>
      repository.updateClassroom(params.classroom);
}

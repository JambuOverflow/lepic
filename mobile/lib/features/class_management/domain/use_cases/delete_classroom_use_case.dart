import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/use_cases/use_case.dart';
import '../repositories/classroom_repository.dart';
import 'classroom_params.dart';

class DeleteClassroom implements UseCase<http.Response, ClassroomParams> {
  final ClassroomRepository repository;

  DeleteClassroom({@required this.repository});

  @override
  Future<Either<Failure, http.Response>> call(ClassroomParams params) =>
      repository.deleteClassroom(params.classroom);
}

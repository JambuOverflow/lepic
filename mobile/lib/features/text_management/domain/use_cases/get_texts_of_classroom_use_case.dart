import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';

class GetTextsOfClassroom implements UseCase<List<MyText>, ClassroomParams> {
  final TextRepository repository;

  GetTextsOfClassroom({@required this.repository});

  @override
  Future<Either<Failure, List<MyText>>> call(ClassroomParams params) =>
      repository.getTextsOfClassroom(params.classroom);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';


class GetTexts implements UseCase<List<Text>, ClassroomParams> {
  final TextRepository repository;

  GetTexts({@required this.repository});

  @override
  Future<Either<Failure, List<Text>>> call(ClassroomParams params) =>
      repository.getTexts(params.classroom);
}

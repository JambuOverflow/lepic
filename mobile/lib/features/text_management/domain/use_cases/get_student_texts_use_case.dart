import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';

import '../../../student_management/domain/use_cases/student_params.dart';
import '../entities/text.dart';
import '../repositories/text_repository.dart';

class GetStudentTextsUseCase implements UseCase<List<MyText>, StudentParams> {
  final TextRepository repository;

  GetStudentTextsUseCase({@required this.repository});

  @override
  Future<Either<Failure, List<MyText>>> call(StudentParams params) =>
      repository.getStudentTexts(params.student);
}

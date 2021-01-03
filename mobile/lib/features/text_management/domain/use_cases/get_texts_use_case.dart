import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';

class GetTexts implements UseCase<List<MyText>, NoParams> {
  final TextRepository repository;

  GetTexts({@required this.repository});

  @override
  Future<Either<Failure, List<MyText>>> call(params) =>
      repository.getTexts();
}

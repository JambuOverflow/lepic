import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';
import '../../../../core/use_cases/use_case.dart';

class DeleteText implements UseCase<void, TextParams> {
  final TextRepository repository;

  DeleteText({@required this.repository});

  @override
  Future<Either<Failure, void>> call(TextParams params) =>
      repository.deleteText(params.text);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';

class GetTextUseCase implements UseCase<MyText, int> {
  final TextRepository repository;

  GetTextUseCase({@required this.repository});

  @override
  Future<Either<Failure, MyText>> call(params) =>
      repository.getText(params);
}

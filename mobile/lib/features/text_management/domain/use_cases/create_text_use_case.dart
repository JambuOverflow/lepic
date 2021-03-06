import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';

class CreateTextUseCase implements UseCase<MyText, TextParams> {
  final TextRepository repository;

  CreateTextUseCase({@required this.repository});

  @override
  Future<Either<Failure, MyText>> call(TextParams params) =>
      repository.createText(params.text);
}

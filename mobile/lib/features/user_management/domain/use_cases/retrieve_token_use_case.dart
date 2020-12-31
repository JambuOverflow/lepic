import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';

class RetrieveTokenUseCase extends UseCase<String, NoParams> {
  final UserRepository repository;

  RetrieveTokenUseCase({@required this.repository});

  @override
  Future<Either<Failure, String>> call(params) =>
      repository.retrieveToken();
}

import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';

class RetrieveTokenUseCase extends UseCase<String, UserParams> {
  final UserRepository repository;

  RetrieveTokenUseCase({@required this.repository});

  @override
  Future<Either<Failure, String>> call(UserParams params) =>
      repository.retrieveToken(params.user);
}

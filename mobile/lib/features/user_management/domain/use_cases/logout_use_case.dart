import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/response.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';

class LogoutCase implements UseCase<Response, UserParams> {
  final UserRepository repository;

  LogoutCase({@required this.repository});

  @override
  Future<Either<Failure, Response>> call(NoParams) async =>
      await repository.logout();
}

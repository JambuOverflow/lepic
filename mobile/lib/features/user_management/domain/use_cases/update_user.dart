import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/response.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';

class UpdateUser extends UseCase<Response, UserParams> {
  final UserRepository repository;

  UpdateUser({@required this.repository});

  @override
  Future<Either<Failure, Response>> call(params) async =>
      await repository.updateUser(params.user, params.token);
}

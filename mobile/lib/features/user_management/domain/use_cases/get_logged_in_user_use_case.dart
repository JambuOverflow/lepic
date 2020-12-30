import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetLoggedInUserCase extends UseCase<User, NoParams> {
  final UserRepository repository;

  GetLoggedInUserCase({@required this.repository});

  @override
  Future<Either<Failure, User>> call(params) async =>
      await repository.getLoggedInUser();
}

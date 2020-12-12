import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';

class CreateNewUser implements UseCase<http.Response, UserParams> {
  final UserRepository repository;

  CreateNewUser({@required this.repository});

  @override
  Future<Either<Failure, http.Response>> call(UserParams params) async =>
      await repository.createUser(params.user);
}

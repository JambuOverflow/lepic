import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:mobile/core/network/response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';

class CreateNewUserCase implements UseCase<Response, UserParams> {

  final UserRepository repository;

  CreateNewUserCase({@required this.repository});

  @override
  Future<Either<Failure, Response>> call(UserParams params) async =>
      await repository.createUser(params.user);
}

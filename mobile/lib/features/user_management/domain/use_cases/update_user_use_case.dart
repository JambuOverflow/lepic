import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/network/response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';
import 'package:http/http.dart' as http;


class UpdateUserCase extends UseCase<Response, UserParams> {
  final UserRepository repository;

  UpdateUserCase({@required this.repository});

  @override
  Future<Either<Failure, Response>> call(params) async =>
      await repository.updateUser(params.user, params.token);
}

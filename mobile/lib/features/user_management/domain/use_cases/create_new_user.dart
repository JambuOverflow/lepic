import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/network/response.dart';
import 'package:mobile/core/use_cases/use_case.dart';

import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateNewUser implements UseCase<void, Params> {
  final UserRepository repository;

  CreateNewUser({@required this.repository});

  @override
  Future<Either<Failure, Response>> call(Params params) async =>
      await repository.createUser(params.user);
}

class Params extends Equatable {
  final User user;

  Params({this.user});

  @override
  List<Object> get props => [Params];
}

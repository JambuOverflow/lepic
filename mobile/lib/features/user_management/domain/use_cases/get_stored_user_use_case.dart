import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetStoredUser extends UseCase<User, NoParams> {
  final UserRepository repository;

  GetStoredUser({@required this.repository});

  @override
  Future<Either<Failure, User>> call(params) async =>
      await repository.getStoredUser();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [NoParams];
}

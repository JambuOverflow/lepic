import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/user_repository.dart';

class LogoutCase implements UseCase<void, NoParams> {
  final UserRepository repository;

  LogoutCase({@required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async => await repository.logout();
}

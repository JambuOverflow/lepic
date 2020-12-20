import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/school_management/domain/repositories/school_repository.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

class GetSchools implements UseCase<List<School>, UserParams> {
  final SchoolRepository repository;

  GetSchools({@required this.repository});

  @override
  Future<Either<Failure, List<School>>> call(UserParams params) =>
      repository.getSchools(params.user);
}

class UserParams extends Equatable {
  final User user;

  UserParams(this.user);

  @override
  List<Object> get props => [UserParams];
}

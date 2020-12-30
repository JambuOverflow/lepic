import 'package:dartz/dartz.dart';
import 'package:mobile/core/network/response.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getLoggedInUser();
  Future<Either<Failure, Response>> createUser(User user);
  Future<Either<Failure, Response>> updateUser(User user, String token);
  Future<Either<Failure, Response>> login(User user);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> retrieveToken();
}

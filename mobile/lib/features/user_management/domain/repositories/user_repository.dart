import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import 'package:http/http.dart' as http;
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getStoredUser();
  Future<Either<Failure, http.Response>> createUser(User user);
  Future<Either<Failure, http.Response>> updateUser(User user);
}

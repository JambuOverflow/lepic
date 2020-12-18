import 'package:dartz/dartz.dart';
import 'package:mobile/core/network/response.dart';

import '../../../../core/error/failures.dart';
import 'package:http/http.dart' as http;
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getStoredUser();
  Future<Either<Failure, Response>> createUser(User user);
  Future<Either<Failure, Response>> updateUser(User user, String token);
  Future<Either<Failure, Response>> login(User user);

}

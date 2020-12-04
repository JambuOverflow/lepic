import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> createUser(User user);
  Future<Either<Failure, void>> updateUser(User user);
}

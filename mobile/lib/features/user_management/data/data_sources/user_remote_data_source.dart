import 'package:mobile/core/network/response.dart';

import '../../domain/entities/user.dart';

abstract class UserRemoteDataSource {
  /// Calls the http://localhost:8080/api/create_user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> createUser(User user);

  /// Calls the http://localhost:8080/api/update-user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> updateUser(User user);
}

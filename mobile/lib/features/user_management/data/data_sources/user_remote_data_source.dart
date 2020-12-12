import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';

abstract class UserRemoteDataSource {
  /// Calls the http://localhost:8080/api/create_user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<http.Response> createUser(User user);

  /// Calls the http://localhost:8080/api/update-user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<http.Response> updateUser(User user);
}

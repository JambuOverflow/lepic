import '../../../../core/data/database.dart';
import '../../../../core/network/response.dart';

abstract class UserRemoteDataSource {
  /// Calls the http://localhost:8080/api/create_user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> createUser(UserModel user);

  /// Calls the http://localhost:8080/api/update-user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> updateUser(UserModel user);
}

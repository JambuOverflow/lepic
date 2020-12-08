import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel].
  ///
  /// Throws [CacheException] if there's no cached [UserModel].
  Future<UserModel> getStoredUser();

  Future<void> cacheUser(UserModel user);
}

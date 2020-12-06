import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [User].
  ///
  /// Throws [CacheException] if there's no cached [User].
  Future<User> getStoredUser();

  Future<void> cacheUser(User user);
}

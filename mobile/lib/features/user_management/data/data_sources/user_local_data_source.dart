import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel].
  ///
  /// Throws [CacheException] if there's no cached [UserModel].
  Future<UserModel> getStoredUser();

  Future<void> cacheUser(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database database;

  UserLocalDataSourceImpl({this.database});

  @override
  Future<int> cacheUser(UserModel user) {
    if (database.activeUser == null)
      return database.insertUser(user);
    else {
      database.updateUser(user);
      return Future.value(user.localId);
    }
  }

  @override
  Future<UserModel> getStoredUser() async {
    final model = await database.activeUser;

    if (model != null)
      return model;
    else
      throw CacheException();
  }
}

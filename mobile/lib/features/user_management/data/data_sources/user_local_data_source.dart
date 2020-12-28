import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';

import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel].
  ///
  /// Throws [CacheException] if there's no cached [UserModel].
  Future<UserModel> getStoredUser();

  Future<void> cacheUser(UserModel user);

  Future<void> storeTokenSecurely(String token);

  Future<String> retrieveToken(User user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database database;
  final FlutterSecureStorage secureStorage;

  UserLocalDataSourceImpl({
    @required this.database,
    @required this.secureStorage,
  });

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

  @override
  Future<void> storeTokenSecurely(String token) async {
    return await secureStorage.write(key: 'token', value: token);
  }

  @override
  Future<String> retrieveToken(User user) {
    // TODO: implement retrieveToken
    throw UnimplementedError();
  }
}

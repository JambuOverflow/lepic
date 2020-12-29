import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';

const String loggedInUserKey = 'loggedInUser';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel].
  ///
  /// Throws [CacheException] if there's no cached [UserModel].
  Future<UserModel> getLoggedInUser();

  Future<void> cacheUser(UserModel user);

  Future<void> storeTokenSecurely({
    @required String token,
    @required UserModel user,
  });

  Future<String> retrieveToken(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database database;
  final FlutterSecureStorage secureStorage;

  UserLocalDataSourceImpl({
    @required this.database,
    @required this.secureStorage,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJsonString = user.toJsonString();
    await secureStorage.write(key: loggedInUserKey, value: userJsonString);
  }

  @override
  Future<UserModel> getLoggedInUser() async {
    try {
      final jsonStringModel = await secureStorage.read(key: loggedInUserKey);

      final jsonModel = jsonDecode(jsonStringModel);

      return UserModel.fromJson(jsonModel);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> storeTokenSecurely({
    @required String token,
    @required UserModel user,
  }) async {
    final userId = user.localId.toString();
    return await secureStorage.write(key: userId, value: token);
  }

  @override
  Future<String> retrieveToken(UserModel user) {
    final key = user.localId.toString();
    final token = secureStorage.read(key: key);

    if (token != null)
      return token;
    else
      throw CacheException();
  }
}

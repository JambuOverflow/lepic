import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/network/response.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_local_data_source.dart';
import '../data_sources/user_remote_data_source.dart';
import 'package:mobile/core/data/database.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Response>> createUser(User user) async {
    if (await networkInfo.isConnected) {
      return await _tryCreateUserAndCacheIt(user);
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> updateUser(User user, String token) async {
    if (await networkInfo.isConnected) {
      return await _tryUpdateUserAndCacheIt(user, token);
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getLoggedInUser() async {
    return await _tryGetLocalUser();
  }

  @override
  Future<Either<Failure, Response>> login(User user) async {
    if (await networkInfo.isConnected) {
      return await _tryLoginUser(user);
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return Right(await localDataSource.logout());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> retrieveToken(User user) async {
    try {
      final userModel = _toModel(user);
      final token = await localDataSource.retrieveToken(userModel);

      return Right(token);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, Response>> _tryLoginUser(User user) async {
    try {
      final userModel = _toModel(user);
      final response = await remoteDataSource.login(userModel);

      if (response is TokenResponse) {
        await localDataSource.storeTokenSecurely(
          token: response.token,
          user: userModel,
        );

        await _getCompleteUserAndCacheIt(response);

        return Right(response);
      } else if (response is InvalidCredentials) {
        return Right(response);
      } else
        return Left(ServerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future _getCompleteUserAndCacheIt(TokenResponse response) async {
    final completeUserModel = await remoteDataSource.getUser(response.token);

    await localDataSource.cacheUser(completeUserModel);
  }

  Future<Either<Failure, Response>> _tryUpdateUserAndCacheIt(
      User user, String token) async {
    try {
      final updatedUser =
          await remoteDataSource.updateUser(_toModel(user), token);
      await localDataSource.cacheUser(_toModel(user));
      return Right(updatedUser);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, Response>> _tryCreateUserAndCacheIt(User user) async {
    try {
      final response = await remoteDataSource.createUser(_toModel(user));
      await localDataSource.cacheUser(_toModel(user));

      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, User>> _tryGetLocalUser() async {
    try {
      final localUser = await localDataSource.getLoggedInUser();
      User user = _toEntity(localUser);

      return Right(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  User _toEntity(UserModel model) {
    return User(
      localId: model.localId,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      password: model.password,
      role: model.role,
    );
  }

  UserModel _toModel(User entity) {
    return UserModel(
      localId: entity.localId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      username: entity.email,
      role: entity.role,
    );
  }
}

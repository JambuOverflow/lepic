import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/response.dart';
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
  Future<Either<Failure, User>> getStoredUser() async {
    return await _tryGetLocalUser();
  }

  Future<Either<Failure, Response>> _tryUpdateUserAndCacheIt(User user, String token) async {
    try {
      final updatedUser = await remoteDataSource.updateUser(_toModel(user), token);
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
      final localUser = await localDataSource.getStoredUser();
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
      role: entity.role,
    );
  }
}

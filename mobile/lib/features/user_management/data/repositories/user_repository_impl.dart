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
      final response = await remoteDataSource.createUser(user);
      await localDataSource.cacheUser(user);

      return Right(response);
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> updateUser(User user) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getStoredUser() async {
    return await _tryGetLocalUser();
  }

  Future<Either<Failure, User>> _tryGetLocalUser() async {
    try {
      final localUser = await localDataSource.getStoredUser();
      return Right(localUser);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

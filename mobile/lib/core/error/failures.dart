import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({this.message});

  @override
  List<Object> get props => [ServerFailure];
}

class CacheFailure extends Failure {
  final String message;

  CacheFailure({this.message});

  @override
  List<Object> get props => [CacheFailure];
}

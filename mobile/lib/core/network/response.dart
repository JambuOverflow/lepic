import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Response extends Equatable {
  @override
  List<Object> get props => [Response];
}

class SuccessfulResponse extends Response {
  final String message;

  SuccessfulResponse({this.message});
}

class TokenResponse extends SuccessfulResponse {
  final String token;

  TokenResponse({@required this.token});
}

class UnsuccessfulResponse extends Response {
  final String message;
  final int statusCode;

  UnsuccessfulResponse({@required this.message, this.statusCode});
}

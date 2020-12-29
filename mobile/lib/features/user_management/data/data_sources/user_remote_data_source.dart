import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';

import '../../../../core/data/database.dart';
import '../../../../core/network/response.dart';

import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  /// Calls the http://localhost:8080/api/create_user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> createUser(UserModel user);

  /// Calls the http://localhost:8080/api/update-user endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> updateUser(UserModel user, String token);

  /// Calls the http://localhost:8080/api/token-auth endpoint
  /// with a token for authentication.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Response> login(UserModel user);
}

/// Localhost - 10.0.2.2 is the address on an android emulator

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String api_url;

  UserRemoteDataSourceImpl({@required this.client, @required this.api_url});

  @override
  Future<Response> createUser(UserModel user) async {
    final jsonUser = user.toJson();

    try {
      final http.Response response = await client.post(
        api_url + 'users/',
        body: json.encode(jsonUser),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
      );

      if (response.statusCode == 201) {
        return SuccessfulResponse();
      } else if (response.body.contains('email')) {
        return EmailAlreadyExists();
      } else
        return UnsuccessfulResponse(
          message: response.body,
          statusCode: response.statusCode,
        );
    } on Exception {
      throw ServerException();
    }
  }

  @override
  Future<Response> updateUser(UserModel user, String token) async {
    final jsonUser = user.toJson();

    try {
      final http.Response response = await client.patch(
        api_url + 'users/' + user.localId.toString(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: json.encode(jsonUser),
      );

      if (response.statusCode == 200)
        return SuccessfulResponse();
      else
        return UnsuccessfulResponse(message: response.body);
    } on Exception {
      throw ServerException();
    }
  }

  @override
  Future<Response> login(UserModel user) async {
    try {
      final http.Response response = await client.post(
        api_url + 'token-auth/',
        body: jsonEncode({
          "username": user.email,
          "password": user.password,
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      print('status code: ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        final token = _extractTokenFromResponse(response);
        return TokenResponse(token: token);
      } else if (response.body.contains('non_field_errors')) {
        return InvalidCredentials();
      } else {
        return UnsuccessfulResponse(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on Exception {
      throw ServerException();
    }
  }

  String _extractTokenFromResponse(http.Response response) {
    try {
      final token = jsonDecode(response.body)['token'];
      return token;
    } on Exception {
      throw ServerException(message: "Can't retrieve token from response");
    }
  }
}

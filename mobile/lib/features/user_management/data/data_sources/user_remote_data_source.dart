import 'dart:convert';

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

const API_URL = 'http://127.0.0.1:8000/api/';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({@required this.client});

  @override
  Future<Response> createUser(UserModel user) async {
    final jsonUser = user.toJson();

    final http.Response response = await client.post(
      API_URL + 'users/',
      body: jsonUser,
    );

    if (response.statusCode == 201) {
      return SuccessfulResponse();
    } else
      return UnsuccessfulResponse(
        message: response.body,
        statusCode: response.statusCode,
      );
  }

  @override
  Future<Response> updateUser(UserModel user, String token) async {
    final jsonUser = user.toJson();

    final http.Response response = await client.patch(
      API_URL + 'users/' + user.localId.toString(),
      headers: {"authorization": "Token " + token},
      body: jsonUser,
    );

    if (response.statusCode == 200)
      return SuccessfulResponse();
    else
      return UnsuccessfulResponse(message: response.body);
  }

  @override
  Future<Response> login(UserModel user) async {
    final http.Response response = await client.post(
      API_URL + 'token-auth/',
      body: jsonEncode({
        "user_name": user.email,
        "password": user.password,
      }),
    );

    if (response.statusCode == 200) {
      final token = _extractTokenFromResponse(response);
      return TokenResponse(token: token);
    } else {
      return UnsuccessfulResponse(
        message: response.body,
        statusCode: response.statusCode,
      );
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

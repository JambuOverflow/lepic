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

  /// Calls the http://localhost:8080/api/users/ endpoint
  /// with a token for authentication.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> getUser(String token);
}

/// Localhost - 10.0.2.2 is the address on an android emulator
const API_URL = 'https://lepic-django.herokuapp.com/api/';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({@required this.client});

  @override
  Future<Response> createUser(UserModel user) async {
    final jsonUser = user.toJson();

    try {
      final http.Response response = await client.post(
        API_URL + 'users/',
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
        API_URL + 'users/' + user.id.toString(),
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
        API_URL + 'token-auth/',
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

  @override
  Future<UserModel> getUser(String token) async {
    try {
      final http.Response response = await client.get(
        API_URL + 'users/',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      );

      if (response.statusCode == 200) {
        final jsonUserModel = json.decode(response.body);
        final userModel = UserModel.fromJson(jsonUserModel);

        return userModel;
      } else
        throw ServerException();
    } on Exception {
      throw ServerException();
    }
  }

  @override
  String _extractTokenFromResponse(http.Response response) {
    try {
      final token = jsonDecode(response.body)['token'];
      return token;
    } on Exception {
      throw ServerException(message: "Can't retrieve token from response");
    }
  }
}

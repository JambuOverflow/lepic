import 'package:flutter/foundation.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required String firstName,
    @required String lastName,
    @required String email,
    @required Role role,
    @required String password,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: role,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: Role.values[json['role']],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "role": role.index,
      "password": password
    };
  }
}

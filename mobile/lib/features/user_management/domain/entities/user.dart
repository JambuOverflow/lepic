import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum Role { teacher, support, researcher }

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final String password;

  User({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.role,
    @required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, email, role, password];
}

import 'package:equatable/equatable.dart';

import '../entities/user.dart';

class UserParams extends Equatable {
  final User user;
  final String token;

  UserParams({this.user, this.token});

  @override
  List<Object> get props => [UserParams];
}

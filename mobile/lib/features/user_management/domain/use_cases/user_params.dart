import 'package:equatable/equatable.dart';

import '../entities/user.dart';

class UserParams extends Equatable {
  final User user;

  UserParams({this.user});

  @override
  List<Object> get props => [UserParams];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  UserFormBloc() : super(UserFormState());

  @override
  Stream<UserFormState> mapEventToState(
    UserFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../widgets/create_user_button.dart';
import '../bloc/user_form_bloc.dart';
import '../widgets/input_fields/confirm_password_input_field.dart';
import '../widgets/input_fields/email_input_field.dart';
import '../widgets/input_fields/password_input_field.dart';
import '../widgets/input_fields/first_name_input_field.dart';
import '../widgets/input_fields/last_name_input_field.dart';
import '../widgets/input_fields/role_dropdown_input_field.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _roleFocusNode = FocusNode();

  bool _ignoreTouch = false;

  @override
  void initState() {
    super.initState();

    _addUnfocusedEventToFocusNodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body:
          BlocConsumer<UserFormBloc, UserFormState>(listener: (context, state) {
        state.status == FormzStatus.submissionInProgress
            ? _ignoreTouch = true
            : _ignoreTouch = false;
      }, builder: (context, state) {
        return IgnorePointer(
          ignoring: _ignoreTouch,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 16),
                FirstNameInputField(focusNode: _firstNameFocusNode),
                const SizedBox(height: 16),
                LastNameInputField(focusNode: _lastNameFocusNode),
                const SizedBox(height: 16),
                EmailInputField(focusNode: _emailFocusNode),
                const SizedBox(height: 32),
                PasswordInputField(focusNode: _passwordFocusNode),
                const SizedBox(height: 16),
                ConfirmPasswordInputField(focusNode: _confirmPasswordFocusNode),
                const SizedBox(height: 32),
                RoleDropdownInputField(focusNode: _confirmPasswordFocusNode),
                const SizedBox(height: 16),
                CreateUserButton(),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _addUnfocusedEventToFocusNodes() {
    _addEventWhenUnfocused(_firstNameFocusNode, FirstNameUnfocused());
    _addEventWhenUnfocused(_lastNameFocusNode, LastNameUnfocused());
    _addEventWhenUnfocused(_emailFocusNode, EmailUnfocused());
    _addEventWhenUnfocused(_passwordFocusNode, PasswordUnfocused());
    _addEventWhenUnfocused(
        _confirmPasswordFocusNode, ConfirmPasswordUnfocused());
    _addEventWhenUnfocused(_roleFocusNode, RoleUnfocused());
  }

  void _addEventWhenUnfocused(FocusNode node, UserFormEvent unfocusedEvent) {
    node.addListener(() {
      if (!node.hasFocus) context.read<UserFormBloc>().add(unfocusedEvent);
    });
  }
}

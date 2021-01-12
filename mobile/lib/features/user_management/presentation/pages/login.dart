import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';

import '../bloc/login_form_bloc.dart';
import '../widgets/invalid_credentials_warning.dart';
import '../widgets/input_fields/user_login_input_field.dart';
import '../widgets/input_fields/password_login_input_field.dart';
import '../widgets/login_button.dart';
import '../widgets/signup_button.dart';
import '../widgets/guest_login_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
      return Scaffold(
        body: Form(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 32),
                Image.asset(
                  "assets/images/JambuOverflow.png",
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Lepic',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: 16),
                UserLoginInputField(key: Key("userLoginField"),),
                SizedBox(height: 8),
                PasswordLoginInputField(key: Key("userPasswordField"),),
                SizedBox(height: 12),
                InvalidCredentialsWarning(isVisible: state.isCredentialInvalid),
                SizedBox(height: 16),
                LoginButton(key: Key("loginButton"),),
                Row(
                  children: [
                    Expanded(child: GuestLoginButton()),
                    SizedBox(width: 16),
                    Expanded(child: SignupButton()),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

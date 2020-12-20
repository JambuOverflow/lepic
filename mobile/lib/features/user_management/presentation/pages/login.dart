import 'package:flutter/material.dart';

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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            UserLoginInputField(nameController: nameController),
            SizedBox(height: 8),
            PasswordLoginInputField(passwordController: passwordController),
            LoginButton(),
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
    );
  }
}

import 'package:flutter/material.dart';

class PasswordLoginInputField extends StatelessWidget {
  const PasswordLoginInputField({
    Key key,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock_rounded),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  final String text;
  const LoginInput({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

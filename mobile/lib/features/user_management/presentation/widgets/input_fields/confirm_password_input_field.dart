import 'package:flutter/material.dart';

class ConfirmPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Confirm password',
      ),
    );
  }
}

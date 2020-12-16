import 'package:flutter/material.dart';

class ConfirmPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Confirm password',
        ),
      ),
    );
  }
}

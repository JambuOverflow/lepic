import 'package:flutter/material.dart';

class FirstNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'First Name',
      ),
    );
  }
}

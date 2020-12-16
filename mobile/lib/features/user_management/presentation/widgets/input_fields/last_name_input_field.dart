import 'package:flutter/material.dart';

class LastNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Last Name',
      ),
    );
  }
}

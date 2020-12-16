import 'package:flutter/material.dart';

class FirstNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'First Name',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(),
        labelText: 'E-mail',
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

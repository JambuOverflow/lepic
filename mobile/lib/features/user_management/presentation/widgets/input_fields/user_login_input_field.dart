import 'package:flutter/material.dart';

class UserLoginInputField extends StatelessWidget {
  const UserLoginInputField({
    Key key,
    @required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'E-mail',
        prefixIcon: Icon(Icons.perm_identity_rounded),
      ),
    );
  }
}

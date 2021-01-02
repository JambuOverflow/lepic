import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/user_management/presentation/widgets/input_fields/role_dropdown_input_field.dart';

class UpdateUser extends StatefulWidget {
  @override
  _UpdateUserStatefulWidgetState createState() =>
      _UpdateUserStatefulWidgetState();
}

class _UpdateUserStatefulWidgetState extends State<UpdateUser> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Role roleSelected = Role.teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current First Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: lastnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current Last Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current E-mail',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm new password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: RoleDropdownInputField(),
            ),
          ],
        ),
      ),
    );
  }
}

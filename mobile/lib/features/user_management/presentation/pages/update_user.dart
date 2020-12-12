import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/presentation/widgets/role_dropdown_button.dart';
import '../widgets/drawer_overlay.dart';

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

  String roleSelected = "Teacher";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      drawer: DrawerOverlay(),
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
              child: RoleDropdownButton(),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: RaisedButton(
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("Changes Saved");
                  print("name: " +
                      firstnameController.text +
                      ' ' +
                      lastnameController.text);
                  print("email: " + emailController.text);
                  print("password: " +
                      passwordController
                          .text); //só falta checar se as senhas batem uma com a outra
                  print("role: " + roleSelected);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

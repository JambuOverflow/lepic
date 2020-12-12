import 'package:flutter/material.dart';
import '../widgets/role_dropdown_button.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final List<String> roles = [
    "Teacher",
    "Pedagogist",
    "Speech therapist",
    "Psychopedagogist",
    "Researcher"
  ];

  String roleSelected = "Teacher";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  labelText: 'First Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: lastnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
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
                  labelText: 'Password',
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
                  labelText: 'Confirm password',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: RoleDropdownButton()),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: RaisedButton(
                child: Text(
                  'Create user',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("user added");
                  print("name: " +
                      firstnameController.text +
                      ' ' +
                      lastnameController.text);
                  print("email: " + emailController.text);
                  print("password: " + passwordController.text);
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

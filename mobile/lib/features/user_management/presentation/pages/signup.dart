import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../widgets/input_fields/confirm_password_input_field.dart';
import '../widgets/input_fields/email_input_field.dart';
import '../widgets/input_fields/password_input_field.dart';
import '../widgets/input_fields/first_name_input_field.dart';
import '../widgets/input_fields/last_name_input_field.dart';
import '../widgets/role_dropdown_button.dart';
import '../../domain/entities/user.dart';

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

  UserBloc _userBloc;

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
    Role roleSelected = Role.teacher;
    _userBloc = BlocProvider.of<UserBloc>(
        context); //Block provider(acho que não precisa mais no main)
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            FirstNameInputField(),
            const SizedBox(height: 16),
            LastNameInputField(),
            const SizedBox(height: 16),
            EmailInputField(),
            const SizedBox(height: 16),
            PasswordInputField(),
            const SizedBox(height: 16),
            ConfirmPasswordInputField(),
            const SizedBox(height: 16),
            RoleDropdownButton(),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserCreated) {
                  print("user added");
                  Navigator.pop(context);
                } else if (state is Error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                return Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Create user',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      print("adding user");
                      print("name: " +
                          firstnameController.text +
                          ' ' +
                          lastnameController.text);
                      print("email: " + emailController.text);
                      print("password: " + passwordController.text);
                      print("role: " + roleSelected.toString());
                      _userBloc.add(
                        CreateNewUserEvent(
                          firstnameController.text,
                          lastnameController.text,
                          emailController.text,
                          roleSelected,
                          passwordController.text,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

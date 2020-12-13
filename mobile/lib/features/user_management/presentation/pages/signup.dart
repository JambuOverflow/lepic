import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/bloc/user_bloc.dart';
import '../widgets/role_dropdown_button.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

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
        padding: EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: firstnameController,
              //tirar o controller e botar essa linha aqui
              //onSubmitted: (value) => submitFirstName(context,value),
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
              padding: const EdgeInsets.all(16.0), child: RoleDropdownButton()),
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
                  print("user added");
                  print("name: " +
                      firstnameController.text +
                      ' ' +
                      lastnameController.text);
                  print("email: " + emailController.text);
                  print("password: " + passwordController.text);
                  print("role: " + roleSelected.toString());
                  Navigator.pop(context);
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
        ]),
      ),
    );
  }

  void submitFirstName(BuildContext context, String firstname) {
    //passar o valor (só um esboço)
    //final userBloc = BlocProvider.of<UserBloc>(context);
    //userBloc.add(SendFirstName(firstname));//aí teria que criar a função que passa o dado pro banco
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 32),
            Image.asset(
              "assets/images/JambuOverflow.png",
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Lepic',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(height: 16),
            UserLoginInputField(nameController: nameController),
            SizedBox(height: 8),
            PasswordLoginInputField(passwordController: passwordController),
            LoginButton(),
            Row(
              children: [
                Expanded(child: GuestLoginButton()),
                SizedBox(width: 16),
                Expanded(child: SignupButton()),
              ],
            )
          ],
        ),
      ),
    );
  }
}

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

class PasswordLoginInputField extends StatelessWidget {
  const PasswordLoginInputField({
    Key key,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock_rounded),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          Navigator.of(context).pushNamed(
            '/home',
          );
        } else if (state is Error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              throw UnimplementedError();
            },
          ),
        );
      },
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/signup'),
    );
  }
}

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Login as guest',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/guest'),
    );
  }
}

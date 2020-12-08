import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class GuestLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            LepicLogo(),
            SizedBox(height: 80),
            LoginInput(text: 'Name'),
            SizedBox(height: 20),
            RoleDropdownButton(),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    ));
  }
}

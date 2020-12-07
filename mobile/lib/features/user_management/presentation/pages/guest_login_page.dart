import 'package:flutter/material.dart';
import '../widgets/login_text_input.dart';

class GuestLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/JambuOverflow.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 80),
            LoginInput(text: 'Name'),
            SizedBox(height: 20),
            // Refactor and Update Dropdown value after selection
            DropdownButton(
              value: '-',
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black87),
              onChanged: (String newValue) {
                newValue = newValue;
              },
              items: <String>['-', 'Student', 'Professor', 'Researcher']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {},
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

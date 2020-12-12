import 'package:flutter/material.dart';

class Guest extends StatefulWidget {
  @override
  _GuestState createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  TextEditingController nameController = TextEditingController();

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
        title: Text('Login as guest'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                hint: Text("Select role"),
                value: roleSelected,
                onChanged: (newValue) {
                  setState(() {
                    roleSelected = newValue;
                  });
                },
                items: roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
            ),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: RaisedButton(
                child: Text(
                  'Create guest user',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("guest added");
                  print("name: " + nameController.text);
                  print("role: $roleSelected");
                  //Navigator.pop(context);
                  Navigator.of(context).pushNamed(
                    '/second',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

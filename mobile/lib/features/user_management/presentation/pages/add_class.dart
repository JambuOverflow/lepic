import 'package:flutter/material.dart';
import 'package:lepic_screen_test/models/class.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  String _levelSelected;
  final List<String> levels = [
    "A1",
    "A2",
    "A3",
    "A4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New class'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Class name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _schoolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'School name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _stateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                hint: Text("Select level"),
                value: _levelSelected,
                onChanged: (newValue) {
                  setState(() {
                    _levelSelected = newValue;
                  });
                },
                items: levels.map<DropdownMenuItem<String>>((String value) {
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
                  'Create class',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("class created");
                  _createClass(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createClass(BuildContext context) {
    final String className = _nameController.text;
    final String classLevel = _levelSelected;
    final String schoolName = _schoolController.text;
    final String coutry = _countryController.text;
    final String state = _stateController.text;
    final String city = _cityController.text;
    if (className != null && classLevel != null) {
      final createdClass = SchoolClass(
        className,
        classLevel,
        city,
        coutry,
        schoolName,
        state,
      );
      Navigator.pop(context, createdClass);
    }
  }
}

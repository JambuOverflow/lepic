//Não tava previsto na sprint - mas é requisito pra classe
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  bool _isDisabled = false;

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
                  labelText: 'Student name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _classController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Student class',
                ),
              ),
            ),
            LabeledSwitch(
                label: 'Is disabled?',
                value: _isDisabled,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                onChanged: (bool newValue) {
                  setState(() {
                    _isDisabled = newValue;
                  });
                }),
            Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: RaisedButton(
                child: Text(
                  'Create student',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  print("student created");
                  _createStudent(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createStudent(BuildContext context) {
    //final String studentName = _nameController.text;
    //final String schoolClass = _classController.text;
  }
}
//}

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Switch(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

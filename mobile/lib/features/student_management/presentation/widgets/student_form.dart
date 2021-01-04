import 'package:flutter/material.dart';

class StudentForm extends StatelessWidget {
  const StudentForm({
    Key key,
    @required TextEditingController firstNameController,
    @required TextEditingController lastNameController,
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        super(key: key);

  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'First name',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Last name',
            ),
          ),
        ],
      ),
    );
  }
}

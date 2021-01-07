import 'package:flutter/material.dart';

import '../../domain/entities/student.dart';

class StudentForm extends StatelessWidget {
  final Student _studentToEdit;

  const StudentForm({
    Key key,
    Student studentToEdit,
    @required TextEditingController firstNameController,
    @required TextEditingController lastNameController,
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _studentToEdit = studentToEdit,
        super(key: key);

  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;

  @override
  Widget build(BuildContext context) {
    _setFormTextToStudentIfExists();

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

  void _setFormTextToStudentIfExists() {
    if (_studentToEdit == null) return;

    _firstNameController.text = _studentToEdit.firstName;
    _lastNameController.text = _studentToEdit.lastName;
  }
}

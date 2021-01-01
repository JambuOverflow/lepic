import 'package:flutter/material.dart';

class ClassroomForm extends StatelessWidget {
  const ClassroomForm({
    Key key,
    @required TextEditingController nameController,
    @required TextEditingController gradeController,
  })  : _nameController = nameController,
        _gradeController = gradeController,
        super(key: key);

  final TextEditingController _nameController;
  final TextEditingController _gradeController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Class name',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _gradeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Class grade',
            ),
          ),
        ],
      ),
    );
  }
}

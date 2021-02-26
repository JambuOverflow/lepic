import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    _nameController.clear();
    _gradeController.clear();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: _nameController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              icon: Icon(Icons.group_rounded),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            keyboardType: TextInputType.number,
            controller: _gradeController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              icon: Icon(Icons.format_list_numbered),
              labelText: 'Grade',
            ),
          ),
        ],
      ),
    );
  }
}

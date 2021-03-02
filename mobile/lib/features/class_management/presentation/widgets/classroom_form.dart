import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassroomForm extends StatelessWidget {
  const ClassroomForm({
    Key key,
    @required TextEditingController nameController,
    @required TextEditingController gradeController,
    @required this.shouldClear,
  })  : _nameController = nameController,
        _gradeController = gradeController,
        super(key: key);

  final TextEditingController _nameController;
  final TextEditingController _gradeController;
  final bool shouldClear;

  @override
  Widget build(BuildContext context) {
    if (shouldClear) {
      _nameController.clear();
      _gradeController.clear();
    }

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
            validator: (value) {
              if (value.isEmpty) return 'Please enter a name';
              return null;
            },
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
            validator: (value) {
              if (value.isEmpty) return 'Please enter a grade';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

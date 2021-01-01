import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';

import 'cancel_button.dart';
import 'classroom_form.dart';

class CreateClassroomDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  CreateClassroomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Classroom'),
      content: ClassroomForm(
        nameController: _nameController,
        gradeController: _gradeController,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            BlocProvider.of<ClassroomBloc>(context).add(
              CreateClassroomEvent(
                name: _nameController.text,
                grade: _gradeController.text,
              ),
            );
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

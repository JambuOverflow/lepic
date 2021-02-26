import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';

import 'classroom_form.dart';

class CreateClassroomDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  CreateClassroomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ClassroomForm(
        nameController: _nameController,
        gradeController: _gradeController,
      ),
      actionsPadding: EdgeInsets.only(right: 8),
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
          child: Text('CREATE'),
        ),
      ],
    );
  }
}

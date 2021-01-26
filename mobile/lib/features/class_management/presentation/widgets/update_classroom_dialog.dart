import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';

import 'classroom_form.dart';

class UpdateClassroomDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  final Classroom classroom;

  UpdateClassroomDialog({Key key, @required this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update classroom'),
      content: ClassroomForm(
        nameController: _nameController,
        gradeController: _gradeController,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            BlocProvider.of<ClassroomBloc>(context).add(
              UpdateClassroomEvent(
                classroom: classroom,
                name: _nameController.text,
                grade: _gradeController.text,
              ),
            );
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}

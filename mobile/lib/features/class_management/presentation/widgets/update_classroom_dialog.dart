import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';

import 'classroom_form.dart';

class UpdateClassroomDialog extends StatefulWidget {
  final Classroom classroom;

  UpdateClassroomDialog({Key key, @required this.classroom}) : super(key: key);

  @override
  _UpdateClassroomDialogState createState() => _UpdateClassroomDialogState();
}

class _UpdateClassroomDialogState extends State<UpdateClassroomDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.classroom.name;
    _gradeController.text = widget.classroom.grade.toString();

    return AlertDialog(
      title: Text(
        'Update ${widget.classroom.name}',
        overflow: TextOverflow.ellipsis,
      ),
      content: Form(
        key: formKey,
        child: ClassroomForm(
          shouldClear: false,
          nameController: _nameController,
          gradeController: _gradeController,
        ),
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              BlocProvider.of<ClassroomBloc>(context).add(
                UpdateClassroomEvent(
                  classroom: widget.classroom,
                  name: _nameController.text,
                  grade: _gradeController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('UPDATE'),
        ),
      ],
    );
  }
}

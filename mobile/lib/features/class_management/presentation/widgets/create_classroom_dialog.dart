import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';

import 'classroom_form.dart';

class CreateClassroomDialog extends StatefulWidget {
  CreateClassroomDialog({Key key}) : super(key: key);

  @override
  _CreateClassroomDialogState createState() => _CreateClassroomDialogState();
}

class _CreateClassroomDialogState extends State<CreateClassroomDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: ClassroomForm(
          shouldClear: true,
          nameController: _nameController,
          gradeController: _gradeController,
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 8),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              BlocProvider.of<ClassroomBloc>(context).add(
                CreateClassroomEvent(
                  name: _nameController.text,
                  grade: _gradeController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('CREATE'),
        ),
      ],
    );
  }
}

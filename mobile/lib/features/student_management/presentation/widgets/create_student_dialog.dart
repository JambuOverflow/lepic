import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import 'student_form.dart';

class CreateStudentDialog extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  CreateStudentDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create student'),
      content: StudentForm(
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            BlocProvider.of<StudentBloc>(context).add(
              CreateNewStudentEvent(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
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

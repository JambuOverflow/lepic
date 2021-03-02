import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import 'student_form.dart';

class CreateStudentDialog extends StatefulWidget {
  CreateStudentDialog({Key key}) : super(key: key);

  @override
  _CreateStudentDialogState createState() => _CreateStudentDialogState();
}

class _CreateStudentDialogState extends State<CreateStudentDialog> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.face),
          SizedBox(width: 8),
          Text('New Student'),
        ],
      ),
      content: Form(
        key: formKey,
        child: StudentForm(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
        ),
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              BlocProvider.of<StudentBloc>(context).add(
                CreateStudentEvent(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('ADD'),
        ),
      ],
    );
  }
}

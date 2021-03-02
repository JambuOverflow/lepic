import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import 'student_form.dart';

class UpdateStudentDialog extends StatefulWidget {
  final Student student;

  UpdateStudentDialog({Key key, @required this.student}) : super(key: key);

  @override
  _UpdateStudentDialogState createState() => _UpdateStudentDialogState();
}

class _UpdateStudentDialogState extends State<UpdateStudentDialog> {
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
          Text('Updating ${widget.student.firstName}'),
        ],
      ),
      content: Form(
        key: formKey,
        child: StudentForm(
          studentToEdit: widget.student,
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
                UpdateStudentEvent(
                  student: widget.student,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
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

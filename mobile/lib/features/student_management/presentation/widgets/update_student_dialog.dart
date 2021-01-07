import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import 'student_form.dart';

class UpdateStudentDialog extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final Student student;

  UpdateStudentDialog({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update student'),
      content: StudentForm(
        studentToEdit: student,
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            BlocProvider.of<StudentBloc>(context).add(
              UpdateStudentEvent(
                student: student,
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import 'update_student_dialog.dart';

class StudentDetailPopupMenuButton extends StatelessWidget {
  final Student student;

  const StudentDetailPopupMenuButton({
    Key key,
    @required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Delete', 'Update'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (choice == 'Delete') Icon(Icons.delete, color: Colors.black),
                if (choice == 'Update') Icon(Icons.edit, color: Colors.black),
                Text(choice),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (value) => handleClick(context, value),
    );
  }

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Delete':
        Navigator.pop(context);
        BlocProvider.of<StudentBloc>(context)
            .add(DeleteStudentEvent(student: student));
        break;
      case 'Update':
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<StudentBloc>(context),
            child: UpdateStudentDialog(student: student),
          ),
        );
        break;
    }
  }
}

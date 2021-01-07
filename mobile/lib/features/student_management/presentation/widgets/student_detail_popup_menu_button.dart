import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

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
        return {'Delete'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (value) => handleClick(context, value),
    );
  }

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Delete':
        BlocProvider.of<StudentBloc>(context)
            .add(DeleteStudentEvent(student: student));
        Navigator.pop(context);
        break;
    }
  }
}

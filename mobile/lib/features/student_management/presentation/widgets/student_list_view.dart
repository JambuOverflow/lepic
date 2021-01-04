import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'student_item.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);

    return Column(
      children: <Widget>[
        Text("Total students:${bloc.students.length}"),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bloc.students.length,
            itemBuilder: (context, index) {
              final student = bloc.students[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(),
                child: StudentItem(index: index),
                onDismissed: (_) => _emitDeleteEventAndShowSnackBar(
                  student: student,
                  context: context,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _emitDeleteEventAndShowSnackBar({
    @required Student student,
    @required BuildContext context,
  }) {
    final bloc = BlocProvider.of<StudentBloc>(context);
    bloc.add(DeleteStudentEvent(student: student));

    Scaffold.of(context).showSnackBar(
      SnackBar(
          content:
              Text("student ${student.firstName} ${student.lastName} deleted")),
    );
  }
}

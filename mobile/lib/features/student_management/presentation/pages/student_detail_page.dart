import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/update_student_dialog.dart';
import '../bloc/student_bloc.dart';
import '../widgets/student_detail_popup_menu_button.dart';
import 'package:mobile/core/presentation/widgets/flight_shuttle_builder.dart';

class StudentDetailPage extends StatelessWidget {
  final int studentIndex;

  const StudentDetailPage({Key key, @required this.studentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);

    return BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
      final student = bloc.students[studentIndex];
      return Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: 'firstName_${student.id}',
            child: Text('${student.firstName} ${student.lastName}'),
            flightShuttleBuilder: flightShuttleBuilder,
          ),
          actions: <Widget>[StudentDetailPopupMenuButton(student: student)],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          child: Icon(Icons.edit),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<StudentBloc>(context),
              child: UpdateStudentDialog(student: student),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Nothing to show here for now...')),
        ),
      );
    });
  }
}

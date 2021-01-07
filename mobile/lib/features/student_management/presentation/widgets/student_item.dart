import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../pages/student_detail_page.dart';
import 'update_student_dialog.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Row(
            children: [
              buildIcon(),
              buildStudentListTile(context, bloc),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<StudentDetailPage>(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: StudentDetailPage(student: student),
            ),
          ),
        );
      },
    );
  }

  Expanded buildStudentListTile(BuildContext context, StudentBloc bloc) {
    return Expanded(
      child: ListTile(
        title: Hero(
          tag: 'firstName_${student.id}',
          child: Text(student.firstName),
        ),
        subtitle: Text(student.lastName),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: UpdateStudentDialog(student: student),
              ),
            );
          },
        ),
      ),
      flex: 5,
    );
  }

  Expanded buildIcon() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          Icons.account_circle_outlined,
          size: 42,
        ),
      ),
      flex: 1,
    );
  }
}

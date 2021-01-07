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
    return GestureDetector(
        child: Card(
          child: ListTile(
            title: Text(student.firstName),
            subtitle: Text(student.lastName),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<UpdateStudentDialog>(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<StudentBloc>(context),
                      child: UpdateStudentDialog(student: student),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<StudentDetailPage>(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<StudentBloc>(context),
                child: StudentDetailPage(student: student),
              ),
            ),
          );
        });
  }
}

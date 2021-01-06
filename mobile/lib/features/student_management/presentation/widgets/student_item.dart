import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/student_detail_page.dart';
import 'package:mobile/features/student_management/presentation/pages/create_student_page.dart';

import 'update_student_dialog.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          child: ListTile(
            title: Text(student.firstName.toString()),
            subtitle: Text(student.classroomId.toString()),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StudentDetailPage(student: student),
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<CreateStudentPage>(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<StudentBloc>(context),
                child: CreateStudentPage(),
              ),
            ),
          );
        });
  }
}

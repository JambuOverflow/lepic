import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/create_student_page.dart';

import '../../domain/entities/student.dart';
import '../pages/student_detail_page.dart';

class StudentItem extends StatelessWidget {
  final Student _student;

  StudentItem(Student student) : this._student = student;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          child: ListTile(
            title: Text(_student.firstName.toString()),
            subtitle: Text(_student.classroomId.toString()),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StudentDetailPage(_student),
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

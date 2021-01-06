import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/student_detail_page.dart';

import 'update_student_dialog.dart';

class StudentItem extends StatelessWidget {
  final Student _student;

  StudentItem(Student student) : this._student = student;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(
          '${_student.firstName}',
        ),
        subtitle: Text(
          'Grade: ${_student.lastName}',
        ),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<UpdateStudentDialog>(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<StudentBloc>(context),
                        child: UpdateStudentDialog(
                          student: _student,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => StudentDetailPage(student: _student)));
        },
      ),
    );
  }
}

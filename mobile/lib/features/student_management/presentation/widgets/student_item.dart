import 'package:flutter/material.dart';

import '../../domain/entities/student.dart';
import '../pages/student_detail_page.dart';

class StudentItem extends StatelessWidget {
  final Student _student;

  StudentItem(Student student) : this._student = student;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

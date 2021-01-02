import 'package:flutter/material.dart';

import '../../domain/entities/student.dart';
import '../widgets/student_item.dart';

class StudentsPage extends StatefulWidget {
  StudentsPage({Key key}) : super(key: key);
  final List<Student> _listStudents = List();

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget._listStudents.length,
        itemBuilder: (context, index) {
          final student = widget._listStudents[index];
          return StudentItem(student);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/add_student',
          );
        },
      ),
    );
  }
}

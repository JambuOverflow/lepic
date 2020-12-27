import 'package:flutter/material.dart';

import '../../../../core/widgets/drawer_overlay.dart';
import '../../domain/entities/student.dart';
import '../widgets/student_item.dart';

class ShowStudents extends StatefulWidget {
  ShowStudents({Key key}) : super(key: key);
  final List<Student> _listStudents = List();

  @override
  _ShowStudentsState createState() => _ShowStudentsState();
}

class _ShowStudentsState extends State<ShowStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Students')),
      drawer: DrawerOverlay(),
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

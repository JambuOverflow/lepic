import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../pages/student_detail_page.dart';

class StudentItem extends StatelessWidget {
  final int studentIndex;

  const StudentItem({Key key, this.studentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);
    final student = bloc.students[studentIndex];

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Row(
            children: [
              buildIcon(),
              buildStudentListTile(context, student),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<StudentDetailPage>(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: StudentDetailPage(studentIndex: studentIndex),
            ),
          ),
        );
      },
    );
  }

  Expanded buildStudentListTile(BuildContext context, Student student) {
    return Expanded(
      child: ListTile(
        title: Hero(
          tag: 'firstName_${student.id}',
          child: Text('${student.firstName} ${student.lastName}', 
            key: Key('${student.id}_fullName'),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
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

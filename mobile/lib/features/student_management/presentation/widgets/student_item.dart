import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';
import 'package:mobile/features/student_management/presentation/pages/student_detail_page.dart';

import 'update_student_dialog.dart';

class StudentItem extends StatelessWidget {
  final int index;

  const StudentItem({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);

    return GestureDetector(
      child: ListTile(
        title: Hero(
          tag: 'name_${bloc.students[index].id}',
          child: Text(
            '${bloc.students[index].firstName}',
          ),
        ),
        subtitle: Text(
          'Grade: ${bloc.students[index].lastName}',
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StudentDetailPage(
              student: bloc.students[index],
            ),
          ),
        ),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) => UpdateStudentDialog(
                  student: bloc.students[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

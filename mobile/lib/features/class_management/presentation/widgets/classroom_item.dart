import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../student_management/presentation/bloc/student_bloc.dart';
import '../bloc/classroom_bloc.dart';
import '../pages/classroom_detail_page.dart';
import '../../domain/entities/classroom.dart';

class ClassroomItem extends StatefulWidget {
  final int index;

  const ClassroomItem({Key key, this.index}) : super(key: key);

  @override
  _ClassroomItemState createState() => _ClassroomItemState();
}

class _ClassroomItemState extends State<ClassroomItem> {
  ClassroomBloc classroomBloc;
  StudentBloc studentBloc;
  Classroom classroom;

  @override
  void initState() {
    classroomBloc = BlocProvider.of<ClassroomBloc>(context);
    studentBloc = BlocProvider.of<StudentBloc>(context);
    classroom = classroomBloc.classrooms[widget.index];

    studentBloc.add(LoadStudentsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Column(
          children: [
            buildTitle(classroom),
            buildBottom(),
          ],
        ),
      ),
      onTap: () => _navigateToDetails(),
    );
  }

  BlocBuilder<StudentBloc, StudentState> buildBottom() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (_, state) {
        final studentsCount = studentBloc.students.length;
        String studentText;
        if (studentsCount == 0)
          studentText = 'No Students';
        else if (studentsCount == 1)
          studentText = '$studentsCount Student';
        else
          studentText = '$studentsCount Students';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 6),
                  Text(
                    studentText,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              FlatButton(
                onPressed: () => _navigateToDetails(),
                child: Text('VIEW'),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildTitle(Classroom classroom) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classroom.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Level ${classroom.grade}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _navigateToDetails() {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: studentBloc,
          child: ClassroomDetailPage(
            classroom: classroomBloc.classrooms[widget.index],
          ),
        ),
      ),
    );
  }
}

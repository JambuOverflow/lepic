import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/presentation/widgets/classroom_card_title.dart';

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
            ClassroomCardTitle(
                title: classroom.name, subtitle: classroom.grade),
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

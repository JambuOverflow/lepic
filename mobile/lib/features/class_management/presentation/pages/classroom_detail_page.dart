import 'package:flutter/material.dart';

import '../../domain/entities/classroom.dart';
import '../../../student_management/presentation/pages/students_page.dart';
import '../../../text_management/presentation/pages/classroom_texts_page.dart';
import '../../../../core/presentation/widgets/flight_shuttle_builder.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassroomDetailPage extends StatelessWidget {
  final Classroom classroom;

  const ClassroomDetailPage({Key key, this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Hero(
                  tag: 'name_${classroom.id}',
                  child: Text('${classroom.name}'),
                  flightShuttleBuilder: flightShuttleBuilder,
                ),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'STUDENTS'),
                    Tab(text: 'TEXTS'),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              StudentsPage(),
              ClassroomTextsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

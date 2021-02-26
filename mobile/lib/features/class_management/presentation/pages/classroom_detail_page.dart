import 'package:flutter/material.dart';
import 'package:mobile/features/class_management/presentation/widgets/classroom_detail_popup_menu_button.dart';

import '../../domain/entities/classroom.dart';
import '../../../student_management/presentation/pages/students_page.dart';
import '../../../../core/presentation/widgets/flight_shuttle_builder.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassroomDetailPage extends StatelessWidget {
  final Classroom classroom;

  const ClassroomDetailPage({Key key, this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'name_${classroom.id}',
          child: Text('${classroom.name}'),
          flightShuttleBuilder: flightShuttleBuilder,
        ),
        actions: [ClassroomDetailPopupMenuButton(classroom: classroom)],
      ),
      body: StudentsPage(),
    );
  }
}

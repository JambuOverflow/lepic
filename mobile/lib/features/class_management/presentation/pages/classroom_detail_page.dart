import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/classroom_bloc.dart';
import '../widgets/classroom_detail_popup_menu_button.dart';
import '../../../student_management/presentation/pages/students_page.dart';
import '../../../../core/presentation/widgets/flight_shuttle_builder.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassroomDetailPage extends StatelessWidget {
  final int classroomIndex;

  const ClassroomDetailPage({Key key, this.classroomIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);

    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        final classroom = bloc.classrooms[classroomIndex];
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
      },
    );
  }
}

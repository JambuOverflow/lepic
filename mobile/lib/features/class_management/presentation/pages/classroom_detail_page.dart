import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../student_management/presentation/bloc/student_bloc.dart';
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
      ),
      body: BlocProvider(
        create: (context) => GetIt.instance<StudentBloc>(param1: classroom),
        child: StudentsPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

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
                  indicatorPadding: EdgeInsets.only(bottom: 2),
                  indicatorColor: Colors.white,
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
              BlocProvider<TextBloc>(
                create: (context) =>
                    GetIt.instance<TextBloc>(param1: classroom),
                child: ClassroomTextsPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'student_statistics_tab.dart';
import '../../../text_management/presentation/pages/student_detail_overview_tab.dart';
import '../../../text_management/presentation/bloc/text_bloc.dart';
import '../../../text_management/presentation/pages/student_texts_page.dart';
import '../bloc/student_bloc.dart';
import '../widgets/student_detail_popup_menu_button.dart';
import '../../../../core/presentation/widgets/flight_shuttle_builder.dart';

class StudentDetailPage extends StatelessWidget {
  final int studentIndex;

  const StudentDetailPage({Key key, @required this.studentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StudentBloc>(context);

    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        final student = bloc.students[studentIndex];

        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Hero(
                      tag: 'firstName_${student.id}',
                      child: Text('${student.firstName} ${student.lastName}'),
                      flightShuttleBuilder: flightShuttleBuilder,
                    ),
                    actions: <Widget>[
                      StudentDetailPopupMenuButton(student: student)
                    ],
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      indicatorPadding: EdgeInsets.only(bottom: 2),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(text: 'TEXTS'),
                        Tab(text: 'STATISTICS'),
                      ],
                    ),
                  ),
                ];
              },
              body: BlocProvider<TextBloc>(
                create: (context) => GetIt.instance<TextBloc>(param1: student),
                child: TabBarView(
                  children: <Widget>[
                    StudentTextsPage(),
                    StudentStatisticsTab(student: student),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../statistics/presentation/bloc/wpm_graph_cubit.dart';
import '../../../statistics/presentation/widgets/wpm_chart_area.dart';
import '../../domain/entities/student.dart';

class StudentStatisticsTab extends StatelessWidget {
  const StudentStatisticsTab({
    Key key,
    @required this.student,
  }) : super(key: key);

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocProvider(
            create: (context) =>
                GetIt.instance.get<WPMGraphCubit>(param1: student),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: WPMChartArea(isOnCorrectionLevel: false),
            ),
          ),
        ],
      ),
    );
  }
}

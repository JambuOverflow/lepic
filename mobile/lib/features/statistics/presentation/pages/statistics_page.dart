import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import '../widgets/result_card.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../../text_management/presentation/widgets/text_area.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _scrollController = ScrollController();
  StatisticBloc bloc;
  PlayerCubit playerCubit;

  @override
  void initState() {
    bloc = BlocProvider.of<StatisticBloc>(context);
    playerCubit = BlocProvider.of<PlayerCubit>(context);

    bloc.add(GetStatisticsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(title: 'Statistics'),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            // TODO: improve readability
            Text(
                '${bloc.student.firstName} ${bloc.student.lastName} had his/her fluency assessed in DATE. He/She read the text in ${playerCubit.durationInSeconds} seconds with Z% of correctness.'),
            SizedBox(height: 8),

            ResultCard(title: 'Results'),
            // SizedBox(height: 8),
            // ResultCard(title: 'Comparative Table'),
            // SizedBox(height: 8),
            // ResultCard(title: 'Comparative Graph'),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

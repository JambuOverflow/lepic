import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import '../../../text_correction/domain/entities/correction.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../../../text_management/domain/entities/text.dart';
import '../widgets/result_card.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../../text_management/presentation/widgets/text_area.dart';

class StatisticsPage extends StatefulWidget {
  final MyText text;
  StatisticsPage({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _scrollController = ScrollController();
  StatisticBloc statistic;
  PlayerCubit playerCubit;
  CorrectionBloc correction;

  @override
  void initState() {
    statistic = BlocProvider.of<StatisticBloc>(context);
    playerCubit = BlocProvider.of<PlayerCubit>(context);
    correction = BlocProvider.of<CorrectionBloc>(context);

    statistic.add(GetStatisticsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int correctness = _getCorrectnessPercentage();
    String duration = _getFormattedDuration();

    return Scaffold(
      appBar: BackgroundAppBar(title: 'Statistics'),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${statistic.student.firstName} ${statistic.student.lastName} had his/her fluency assessed in DATE. He/She read the text in $duration, with $correctness% of correctness.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            ResultCard(title: 'Results'),
            SizedBox(height: 8),
            ResultCard(title: 'Comparative Table'),
            SizedBox(height: 8),
            ResultCard(title: 'Comparative Graph'),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  int _getCorrectnessPercentage() {
    var normal = 1 - (correction.mistakes.length / widget.text.numberOfWords);
    return (normal * 100).round();
  }

  String _getFormattedDuration() {
    var parts = playerCubit.formattedDuration().split(':');
    var minutes = parts[0];
    var seconds = parts[1];
    return '$minutes minutes and $seconds seconds';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/statistics/presentation/widgets/footnote.dart';
import 'package:mobile/features/statistics/presentation/widgets/measure_card.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<StatisticBloc>(context);
    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Results',
      ),
      body: Scrollbar(
        child: ListView(
          // padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            MeasureCard(
                measure: 'Total Reading Time*',
                result: bloc.numberOfWordsReadPerMinute),
            MeasureCard(
                measure: 'Number of Words Read Per Minute*',
                result: bloc.numberOfWordsReadPerMinute),
            MeasureCard(
                measure: 'Number of Words Read in the First Minute*',
                result: bloc.numberOfWordsReadPerMinute),
            MeasureCard(
                measure: 'Number of Correct Words Read in the First Minute*',
                result: bloc.numberOfWordsReadPerMinute),
            MeasureCard(
                measure: 'Total Words Misread*',
                result: bloc.numberOfWordsReadPerMinute),
            Footnote(),
          ],
        ),
      ),
    );
  }
}

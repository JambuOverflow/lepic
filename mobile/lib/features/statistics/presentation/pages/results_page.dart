import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../bloc/statistic_bloc.dart';
import '../widgets/measure_card.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statistic = BlocProvider.of<StatisticBloc>(context);
    final playerCubit = BlocProvider.of<PlayerCubit>(context);
    final correction = BlocProvider.of<CorrectionBloc>(context);

    return Column(
      children: [
        MeasureCard(
            measure: 'Total Reading Time',
            result: playerCubit.formattedDuration()),
        MeasureCard(
            measure: 'Total Words Misread',
            result: correction.mistakes.length.toString()),
        MeasureCard(
          measure: 'Words Read Per Minute',
          result: statistic.numberOfWordsReadPerMinute.toStringAsFixed(2),
        ),
        MeasureCard(
          measure: 'Correct Words Read Per Minute',
          result:
              statistic.numberOfCorrectWordsReadPerMinute.toStringAsFixed(2),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

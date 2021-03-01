import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../bloc/wpm_graph_cubit.dart';
import 'wpm_line_chart.dart';

class WPMChartArea extends StatefulWidget {
  @override
  _WPMChartAreaState createState() => _WPMChartAreaState();
}

class _WPMChartAreaState extends State<WPMChartArea> {
  WPMGraphCubit cubit;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  double maxY = 0;
  double minY = 0;

  int assignmentIndex;

  @override
  void initState() {
    cubit = BlocProvider.of<WPMGraphCubit>(context);
    cubit.load();
    assignmentIndex =
        BlocProvider.of<CorrectionBloc>(context).textCubit.assignmentIndex;
    super.initState();
  }

  bool correctOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WPMGraphCubit, LineGraphState>(
      builder: (context, state) {
        if (state is LineGraphLoaded) {
          if (correctOnly) {
            maxY = state.correctWordsReadPerMinuteResults.reduce(max);
            minY = state.correctWordsReadPerMinuteResults.reduce(min);
          } else {
            maxY = state.wordsReadPerMinuteResults.reduce(max);
            minY = state.wordsReadPerMinuteResults.reduce(min);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black87,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 24,
                            left: 12,
                            top: 46,
                            bottom: 12,
                          ),
                          child: WPMLineChart(
                            data: correctOnly
                                ? state.correctWordsReadPerMinuteResults
                                : state.wordsReadPerMinuteResults,
                            readingStatusMap: correctOnly
                                ? state.correctWpmToReadingStatus
                                : state.wpmToReadingStatus,
                            gradientColors: gradientColors,
                            minY: minY,
                            maxY: maxY,
                            indexToHighlight: assignmentIndex,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: OutlineButton(
                        child: correctOnly
                            ? Text('SHOW ALL')
                            : Text('SHOW CORRECT WORDS ONLY'),
                        onPressed: () =>
                            setState(() => correctOnly = !correctOnly),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}

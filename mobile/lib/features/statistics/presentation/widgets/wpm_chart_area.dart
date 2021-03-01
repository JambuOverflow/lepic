import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../bloc/wpm_graph_cubit.dart';
import 'wpm_line_chart.dart';

class WPMChartArea extends StatefulWidget {
  final bool isOnCorrectionLevel;

  const WPMChartArea({Key key, @required this.isOnCorrectionLevel})
      : super(key: key);

  @override
  _WPMChartAreaState createState() => _WPMChartAreaState();
}

class _WPMChartAreaState extends State<WPMChartArea> {
  WPMGraphCubit cubit;

  List<Color> gradientColors = [
    const Color(0xff5F63B4),
    const Color(0xff5D3FA2),
    const Color(0xffA32876),
  ];

  double maxY = 0;
  double minY = 0;

  int assignmentIndex;

  @override
  void initState() {
    cubit = BlocProvider.of<WPMGraphCubit>(context);
    cubit.load();
    if (widget.isOnCorrectionLevel)
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Reading Assessment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '(Interactive)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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

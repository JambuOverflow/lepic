import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/statistics/domain/entities/statistic.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_area.dart';

class StatisticsPage extends StatelessWidget {
  final Statistic _statistic;
  final _scrollController = ScrollController();

  StatisticsPage({Key key, @required Statistic statistic})
      : _statistic = statistic,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(title: 'Statistics'),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: Column(
          children: [
            TextArea(
              scrollControler: _scrollController,
              textBody: _statistic.cardContent,
              tag: '${_statistic.cardContent}_stat',
            ),
          ],
        ),
      ),
    );
  }
}

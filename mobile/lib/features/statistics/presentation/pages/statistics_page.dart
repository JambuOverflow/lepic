import 'package:flutter/material.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import '../widgets/result_card.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../../text_management/presentation/widgets/text_area.dart';

class StatisticsPage extends StatelessWidget {
  final StatisticBloc bloc;
  final _scrollController = ScrollController();

  StatisticsPage({Key key, @required this.bloc}) : super(key: key);

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
            TextArea(
              scrollControler: _scrollController,
              textBody: bloc.cardContent,
              tag: '${bloc.cardContent}_stat',
            ),
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
}

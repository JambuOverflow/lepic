import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../domain/entities/statistic.dart';
import '../widgets/info_card.dart';
import '../../../text_management/presentation/widgets/text_area.dart';

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
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextArea(
              scrollControler: _scrollController,
              textBody: _statistic.cardContent,
              tag: '${_statistic.cardContent}_stat',
            ),
            InfoCard(
              content: [buildButtons(context)],
              enabled: true,
              title: 'Results',
              titleBackgroundColor: Colors.blueGrey.shade800,
              titleColor: Colors.white,
            ),
            SizedBox(height: 8),
            InfoCard(
              content: [buildButtons(context)],
              enabled: true,
              title: 'Comparative Table',
              titleBackgroundColor: Colors.blueGrey.shade800,
              titleColor: Colors.white,
            ),
            SizedBox(height: 8),
            InfoCard(
              content: [buildButtons(context)],
              enabled: true,
              title: 'Comparative Graph',
              titleBackgroundColor: Colors.blueGrey.shade800,
              titleColor: Colors.white,
            ),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          textColor: Colors.black87,
          child: Text(
            'View',
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

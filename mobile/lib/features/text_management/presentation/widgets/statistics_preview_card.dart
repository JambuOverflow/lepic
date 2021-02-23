import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/flight_shuttle_builder.dart';
import 'package:mobile/features/statistics/domain/entities/statistic.dart';
import 'package:mobile/features/statistics/presentation/pages/statistics_page.dart';
import 'preview_card.dart';

class StatisticsPreviewCard extends StatelessWidget {
  final Statistic _statistic;

  const StatisticsPreviewCard({
    Key key,
    @required Statistic statistic,
  })  : _statistic = statistic,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      title: 'STATISTICS',
      content: [
        buildTextPreviewArea(context),
        buildButtons(context),
      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            child: Text('SEE MORE'),
            onPressed: () => navigateToDetails(context),
          ),
        ],
      ),
    );
  }

  Padding buildTextPreviewArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.blue[100].withOpacity(0.5),
        highlightColor: Colors.blue[100].withAlpha(0),
        onTap: () => navigateToDetails(context),
        child: Hero(
          tag: '${_statistic.cardContent}_stat',
          flightShuttleBuilder: flightShuttleBuilder,
          child: Text(
            _statistic.cardContent,
            maxLines: 6,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StatisticsPage(statistic: _statistic),
      ),
    );
  }
}

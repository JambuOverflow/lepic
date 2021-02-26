import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/presentation/widgets/flight_shuttle_builder.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/statistics/presentation/pages/statistics_page.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';
import 'preview_card.dart';

class StatisticsPreviewCard extends StatefulWidget {
  const StatisticsPreviewCard({
    Key key,
  }) : super(key: key);

  @override
  _StatisticsPreviewCardState createState() => _StatisticsPreviewCardState();
}

class _StatisticsPreviewCardState extends State<StatisticsPreviewCard> {
  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      title: 'STATISTICS',
      content: [
        buildTextPreviewArea(),
        buildButtons(),
      ],
    );
  }

  Padding buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            child: Text('SEE MORE'),
            onPressed: () => navigateToDetails(),
          ),
        ],
      ),
    );
  }

  Padding buildTextPreviewArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.blue[100].withOpacity(0.5),
        highlightColor: Colors.blue[100].withAlpha(0),
        onTap: () {
          print('aqui');
          navigateToDetails();
        },
        child: Hero(
          tag: 'bunda',
          flightShuttleBuilder: flightShuttleBuilder,
          child: Text(
            "bloc.cardContent",
            maxLines: 6,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void navigateToDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => GetIt.instance.get<StatisticBloc>(
            param1: BlocProvider.of<TextBloc>(context).student,
            param2: BlocProvider.of<AudioBloc>(context).audio,
          ),
          child: StatisticsPage(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../statistics/presentation/bloc/statistic_bloc.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';
import '../bloc/assignment_status_cubit.dart';
import '../bloc/text_bloc.dart';
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
    final bloc = BlocProvider.of<AssignmentStatusCubit>(context);

    return BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
      builder: (context, state) {
        return bloc.state.index >= AssignmentStatus.waiting_report.index
            ? _AvailableStatisticsCard()
            : _UnavailableStatisticsCard();
      },
    );
  }
}

class _UnavailableStatisticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: false,
      title: 'STATISTICS',
      titleBackgroundColor: Colors.black87,
      titleColor: Colors.white,
      content: [
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Column(
            children: [
              _CardTitle(enabled: false),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'UNAVAILABLE',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvailableStatisticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      titleBackgroundColor: Colors.black87,
      titleColor: Colors.white,
      title: 'STATISTICS',
      content: [
        InkWell(
          onTap: () => navigateToDetails(context),
          child: Column(
            children: [
              _CardTitle(enabled: true),
              buildButtons(context),
            ],
          ),
        ),
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
            child: Text('VIEW'),
            onPressed: () => navigateToDetails(context),
          ),
        ],
      ),
    );
  }

  void navigateToDetails(BuildContext context) {
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

class _CardTitle extends StatelessWidget {
  final bool enabled;

  const _CardTitle({
    Key key,
    @required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 64,
        ),
        child: Image.asset(
          enabled
              ? 'assets/images/statistics.png'
              : 'assets/images/statistics-disabled.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

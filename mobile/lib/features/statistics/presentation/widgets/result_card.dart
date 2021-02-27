import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/statistics/presentation/pages/results_page.dart';

import 'more_info_dialog.dart';

class ResultCard extends StatelessWidget {
  final String title;

  const ResultCard({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          buildTitleBar(context),
          buildContent(context),
        ],
      ),
    );
  }

  Container buildTitleBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.white,
              iconSize: 16,
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) => MoreInfoDialog(title: title),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          textColor: Colors.black87,
          child: Text(
            'View',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  child: ResultsPage(),
                  providers: [
                    BlocProvider.value(
                        value: BlocProvider.of<StatisticBloc>(context)),
                    BlocProvider.value(
                        value: BlocProvider.of<PlayerCubit>(context))
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

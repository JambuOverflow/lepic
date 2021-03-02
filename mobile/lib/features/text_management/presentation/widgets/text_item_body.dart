import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../../../statistics/presentation/bloc/statistic_bloc.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../bloc/assignment_status_cubit.dart';
import '../bloc/single_text_cubit.dart';
import '../bloc/text_bloc.dart';
import '../../domain/entities/text.dart';

class TextItemBody extends StatefulWidget {
  final int index;
  final MyText text;
  final Function onTap;

  const TextItemBody({
    Key key,
    @required this.text,
    @required this.index,
    @required this.onTap,
  }) : super(key: key);

  @override
  _TextItemBodyState createState() => _TextItemBodyState();
}

class _TextItemBodyState extends State<TextItemBody> {
  @override
  Widget build(BuildContext context) {
    final statusCubit = BlocProvider.of<AssignmentStatusCubit>(context);
    return BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (statusCubit.state.index >=
                      AssignmentStatus.waiting_report.index)
                    FlatButton(
                      child: Text('STATISTICS'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            child: StatisticsPage(
                              text: BlocProvider.of<SingleTextCubit>(context)
                                  .state,
                            ),
                            providers: [
                              BlocProvider(
                                create: (_) =>
                                    GetIt.instance.get<StatisticBloc>(
                                  param1: BlocProvider.of<TextBloc>(context)
                                      .student,
                                  param2:
                                      BlocProvider.of<AudioBloc>(context).audio,
                                ),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<PlayerCubit>(context),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<CorrectionBloc>(context),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  FlatButton(
                    child: Text('VIEW'),
                    onPressed: widget.onTap,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

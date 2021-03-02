import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_correction/presentation/bloc/correction_bloc.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/bloc/assignment_status_cubit.dart';
import 'package:mobile/features/text_management/presentation/bloc/single_text_cubit.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_item_body.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_item_title.dart';

import '../pages/assignment_detail_page.dart';
import '../bloc/text_bloc.dart';

class TextItem extends StatefulWidget {
  final int textIndex;

  const TextItem({
    Key key,
    @required this.textIndex,
  }) : super(key: key);

  @override
  _TextItemState createState() => _TextItemState();
}

class _TextItemState extends State<TextItem> {
  TextBloc textBloc;
  AudioBloc audioBloc;
  CorrectionBloc correctionBloc;
  StatisticBloc statisticBloc;
  SingleTextCubit textCubit;
  AssignmentStatusCubit assignment;
  PlayerCubit player;

  Student student;

  @override
  void initState() {
    textBloc = BlocProvider.of<TextBloc>(context);
    student = textBloc.student;
    super.initState();
  }

  MyText get text => textBloc.texts[widget.textIndex];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => textCubit = SingleTextCubit(
            textBloc: textBloc,
            assignmentIndex: widget.textIndex,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => correctionBloc = GetIt.instance.get<CorrectionBloc>(
            param1: textCubit,
            param2: student,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => audioBloc = GetIt.instance.get<AudioBloc>(
            param1: StudentTextParams(text: text, student: student),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => player = PlayerCubit(audioBloc),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => statisticBloc = GetIt.instance.get<StatisticBloc>(
            param1: student,
            param2: audioBloc.audio,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => assignment = AssignmentStatusCubit(
            audioBloc: audioBloc,
            textBloc: textBloc,
            correctionBloc: correctionBloc,
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Card(
          elevation: 4,
          child: InkWell(
            child: Column(
              children: [
                TextItemTitle(index: widget.textIndex),
                TextItemBody(
                  text: text,
                  index: widget.textIndex,
                  onTap: () => goToAssignmentDetails(context),
                ),
              ],
            ),
            onTap: () => goToAssignmentDetails(context),
          ),
        ),
      ),
    );
  }

  Future goToAssignmentDetails(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: textBloc),
            BlocProvider.value(value: audioBloc),
            BlocProvider.value(value: audioBloc),
            BlocProvider.value(value: correctionBloc),
            BlocProvider.value(value: statisticBloc),
            BlocProvider.value(value: textCubit),
            BlocProvider.value(value: assignment),
            BlocProvider.value(value: player),
          ],
          child: AssigmentDetailPage(textIndex: widget.textIndex),
        ),
      ),
    );
  }
}

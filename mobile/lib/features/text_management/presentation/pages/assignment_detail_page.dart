import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/statistics/domain/entities/statistic.dart';
import 'package:mobile/features/statistics/presentation/bloc/statistic_bloc.dart';
import 'package:mobile/features/text_management/presentation/widgets/statistics_preview_card.dart';

import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/single_text_cubit.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';

import '../bloc/assignment_status_cubit.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../text_correction/domain/use_cases/get_correction_use_case.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../widgets/assignment_contextual_floating_action_button.dart';
import '../widgets/audio_preview_card.dart';
import '../widgets/correction_preview_cards.dart';
import '../widgets/text_preview_card.dart';
import '../widgets/app_bar_bottom_text_title.dart';
import '../../../student_management/domain/entities/student.dart';
import '../../domain/entities/text.dart';
import '../bloc/text_bloc.dart';

class AssigmentDetailPage extends StatefulWidget {
  final int textIndex;

  const AssigmentDetailPage({
    Key key,
    @required this.textIndex,
  }) : super(key: key);

  @override
  _AssigmentDetailPageState createState() => _AssigmentDetailPageState();
}

class _AssigmentDetailPageState extends State<AssigmentDetailPage> {
  final _scrollController = ScrollController();

  TextBloc textBloc;
  AudioBloc audioBloc;
  CorrectionBloc correctionBloc;
  StatisticBloc statisticBloc;
  SingleTextCubit textCubit;

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
          create: (_) => PlayerCubit(audioBloc),
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
          create: (_) => AssignmentStatusCubit(
            audioBloc: audioBloc,
            textBloc: textBloc,
            correctionBloc: correctionBloc,
          ),
        ),
      ],
      child: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          audioBloc.add(LoadAudioEvent());

          return Scaffold(
            appBar: AppBar(
              title: Text('${student.firstName} ${student.lastName}'),
              bottom: AppBarBottomTextTitle(title: text.title),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AssignmentContextualFloatingActionButton(),
            body: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                children: [
                  TextPreviewCard(text: text),
                  SizedBox(height: 8),
                  AudioPreviewCard(),
                  SizedBox(height: 8),
                  CorrectionPreviewCard(),
                  SizedBox(height: 8),
                  StatisticsPreviewCard(text: text),
                  SizedBox(height: 64),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

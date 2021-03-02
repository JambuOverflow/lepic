import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../statistics/presentation/bloc/statistic_bloc.dart';
import '../widgets/assignment_popup_menu_button.dart';
import '../widgets/statistics_preview_card.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../bloc/single_text_cubit.dart';
import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../bloc/assignment_status_cubit.dart';
import '../../../text_correction/domain/use_cases/get_correction_use_case.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';
import 'package:mobile/features/text_management/presentation/widgets/statistics_preview_card.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
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
  AssignmentStatusCubit statusCubit;

  Student student;

  @override
  void initState() {
    textBloc = BlocProvider.of<TextBloc>(context);
    audioBloc = BlocProvider.of<AudioBloc>(context);

    student = textBloc.student;
    super.initState();
  }

  MyText get text => textBloc.texts[widget.textIndex];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        audioBloc.add(LoadAudioEvent());
        return Scaffold(
          appBar: AppBar(
            title: Text('${student.firstName} ${student.lastName}'),
            bottom: AppBarBottomTextTitle(title: text.title),
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
          create: (_) => statusCubit = AssignmentStatusCubit(
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
              actions: [AssignmentPopupMenuButton()],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AssignmentContextualFloatingActionButton(),
            body: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
                builder: (context, state) {
                  return ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    children: _getViewBasedOnAvailability(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getViewBasedOnAvailability() {
    switch (statusCubit.state) {
      case AssignmentStatus.waiting_audio:
        return _textAvailableView();
      case AssignmentStatus.waiting_correction:
        return _audioAvailableView();
      case AssignmentStatus.waiting_report:
        return _correctionAvailableView();
      default:
        return _textAvailableView();
    }
  }

  List<Widget> _textAvailableView() {
    return [
      TextPreviewCard(text: text),
      SizedBox(height: 8),
      AudioPreviewCard(),
      SizedBox(height: 8),
      CorrectionPreviewCard(),
      SizedBox(height: 8),
      StatisticsPreviewCard(text: text),
      SizedBox(height: 64),
    ];
  }

  List<Widget> _audioAvailableView() {
    return [
      AudioPreviewCard(),
      SizedBox(height: 8),
      TextPreviewCard(text: text),
      SizedBox(height: 8),
      CorrectionPreviewCard(),
      SizedBox(height: 8),
      StatisticsPreviewCard(text: text),
      SizedBox(height: 64),
    ];
  }

  List<Widget> _correctionAvailableView() {
    return [
      StatisticsPreviewCard(text: text),
      SizedBox(height: 8),
      CorrectionPreviewCard(),
      SizedBox(height: 8),
      AudioPreviewCard(),
      SizedBox(height: 8),
      TextPreviewCard(text: text),
      SizedBox(height: 64),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
          create: (_) => correctionBloc = GetIt.instance.get<CorrectionBloc>(
            param1: StudentTextParams(text: text, student: student),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => audioBloc = GetIt.instance.get<AudioBloc>(
            param1: StudentTextParams(text: text, student: student),
          ),
        ),
        BlocProvider(
          create: (_) => AssignmentStatusCubit(
            audioBloc: audioBloc,
            textBloc: textBloc,
            correctionBloc: correctionBloc,
          ),
        ),
      ],
      child: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
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
                padding: EdgeInsets.all(16),
                children: [
                  TextPreviewCard(text: text),
                  SizedBox(height: 8),
                  AudioPreviewCard(),
                  SizedBox(height: 8),
                  CorrectionPreviewCard(),
                  SizedBox(height: 8),
                  Card(child: Container(height: 200)),
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

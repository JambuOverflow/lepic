import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/statistics/presentation/pages/statistics_page.dart';
import 'package:mobile/features/text_management/presentation/widgets/preview_card.dart';
import 'package:mobile/features/text_management/presentation/widgets/statistics_preview_card.dart';

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
  CorrectionBloc correctionBloc;

  Student student;

  @override
  void initState() {
    textBloc = BlocProvider.of<TextBloc>(context);
    student = textBloc.student;
    super.initState();
  }

  MyText get _text => textBloc.texts[widget.textIndex];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => correctionBloc = GetIt.instance.get<CorrectionBloc>(
            param1: StudentTextParams(text: _text, student: student),
          ),
        ),
      ],
      child: BlocBuilder<TextBloc, TextState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${student.firstName} ${student.lastName}'),
              bottom: AppBarBottomTextTitle(title: _text.title),
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
                  TextPreviewCard(text: _text),
                  SizedBox(height: 8),
                  AudioPreviewCard(),
                  SizedBox(height: 8),
                  CorrectionPreviewCard(
                    params: StudentTextParams(student: student, text: _text),
                  ),
                  SizedBox(height: 8),
                  StatisticsPreviewCard(student: student),
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

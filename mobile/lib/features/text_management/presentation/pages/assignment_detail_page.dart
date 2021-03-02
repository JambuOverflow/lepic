import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../bloc/text_bloc.dart';
import '../bloc/assignment_status_cubit.dart';
import 'audio_assignment_floating_button.dart';

class AssignmentContextualFloatingActionButton extends StatelessWidget {
  AssignmentContextualFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssignmentStatusCubit(
        audioBloc: BlocProvider.of<AudioBloc>(context),
        textBloc: BlocProvider.of<TextBloc>(context),
        correctionBloc: BlocProvider.of<CorrectionBloc>(context),
      ),
      child: BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
        builder: (_, state) => getContextualButton(context, state),
      ),
    );
  }

  Widget getContextualButton(BuildContext context, AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.waiting_audio:
        return AudioAssignmentFloatingButton();
      case AssignmentStatus.loading:
        return loadingButton();
      case AssignmentStatus.waiting_correction:
        return correctionButton();
      default:
        return Container();
    }
  }

  FloatingActionButton loadingButton() {
    return FloatingActionButton.extended(
      icon: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
      label: Text(' Loading...'),
      backgroundColor: Colors.grey,
      onPressed: null,
    );
  }

  FloatingActionButton correctionButton() {
    return FloatingActionButton.extended(
      onPressed: null,
      label: Text('Correct Text'),
      icon: Icon(Icons.assignment_turned_in),
    );
  }
}

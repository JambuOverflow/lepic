import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'correction_assignment_floating_button.dart';
import '../bloc/assignment_status_cubit.dart';
import 'audio_assignment_floating_button.dart';

class AssignmentContextualFloatingActionButton extends StatefulWidget {
  @override
  _AssignmentContextualFloatingActionButtonState createState() =>
      _AssignmentContextualFloatingActionButtonState();
}

class _AssignmentContextualFloatingActionButtonState
    extends State<AssignmentContextualFloatingActionButton> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
      key: key,
      builder: (_, state) => getContextualButton(state),
    );
  }

  Widget getContextualButton(AssignmentStatus status) {
    print(status);
    switch (status) {
      case AssignmentStatus.loading:
        return loadingButton();
      case AssignmentStatus.waiting_audio:
        return AudioAssignmentFloatingButton(parentKey: key);
      case AssignmentStatus.waiting_correction:
        return CorrectionAssignmentFloatingButton();
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
}

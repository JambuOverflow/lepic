import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import '../../../text_correction/presentation/pages/correction_page.dart';

class CorrectionAssignmentFloatingButton extends StatelessWidget {
  const CorrectionAssignmentFloatingButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<CorrectionBloc>(context),
            child: CorrectionPage(),
          ),
        ),
      ),
      label: Text('Start Correction'),
      icon: Icon(Icons.assignment_turned_in),
    );
  }
}

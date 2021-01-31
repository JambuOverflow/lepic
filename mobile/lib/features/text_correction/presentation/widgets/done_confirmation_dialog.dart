import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_correction/presentation/bloc/correction_bloc.dart';

class DoneConfirmationDialog extends StatelessWidget {
  const DoneConfirmationDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Finish Correction?"),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        FlatButton(
          onPressed: () {
            BlocProvider.of<CorrectionBloc>(context)
                .add(FinishCorrectionEvent());
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('FINISH'),
        ),
      ],
    );
  }
}

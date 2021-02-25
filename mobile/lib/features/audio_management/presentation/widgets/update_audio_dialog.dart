import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';

import 'audio_form.dart';

class UpdateAudioDialog extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final AudioBloc bloc;

  UpdateAudioDialog({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update title'),
      content: AudioForm(titleController: _titleController),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            bloc.add(UpdateAudioEvent(
              oldAudio: bloc.audio,
              audioData: bloc.audio.data,
              title: _titleController.text,
            ));
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}

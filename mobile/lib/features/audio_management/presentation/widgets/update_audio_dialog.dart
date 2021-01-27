import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/utils/add_or_update_audio.dart';

import 'audio_form.dart';

class UpdateAudioDialog extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final AudioBloc bloc;

  UpdateAudioDialog({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update audio'),
      content: AudioForm(
        titleController: _titleController,
        audio: bloc.audio,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            addOrUpdateAudio(bloc);
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}

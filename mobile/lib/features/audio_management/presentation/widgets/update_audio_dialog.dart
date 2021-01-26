import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/cancel_button.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';

import 'audio_form.dart';

class UpdateAudioDialog extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();

  final AudioEntity audio;

  UpdateAudioDialog({Key key, @required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update audio'),
      content: AudioForm(
        titleController: _titleController,
        audio: audio,
      ),
      actions: <Widget>[
        CancelButton(),
        FlatButton(
          onPressed: () {
            BlocProvider.of<AudioBloc>(context).add(
              UpdateAudioEvent(
                  oldAudio: audio,
                  audioData: audio.audioData,
                  title: _titleController.text),
            );
            Navigator.pop(context);
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../domain/entities/audio.dart';
import '../bloc/audio_bloc.dart';
import '../utils/audio_picker.dart';

class AppBarIconBuilder extends StatelessWidget {
  final AudioBloc bloc;

  const AppBarIconBuilder({Key key, this.bloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.attach_file_sharp),
          onPressed: () async {
            final audio = await AudioPicker.pick();

            if (audio != null) updateOrCreateEvent(audio);
          },
        ),
        if (bloc.isAudioAttached)
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.add(DeleteAudioEvent(audio: bloc.audio));
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  void updateOrCreateEvent(AudioEntity audio) {
    bloc.add(
      bloc.isAudioAttached
          ? UpdateAudioEvent(
              oldAudio: bloc.audio,
              audioData: audio.audioData,
              title: audio.title,
            )
          : CreateAudioEvent(
              audioData: audio.audioData,
              title: audio.title,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/utils/add_or_update_audio.dart';

class AppBarIconBuilder extends StatelessWidget {
  final AudioBloc bloc;

  const AppBarIconBuilder({Key key, this.bloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(bloc.isAudioAttached ? Icons.delete : Icons.attach_file_sharp),
      onPressed: () {
        if (bloc.isAudioAttached) {
          bloc.add(DeleteAudioEvent(audio: bloc.audio));
          Navigator.pop(context);
        } else
          addOrUpdateAudio(bloc);
      },
    );
  }
}

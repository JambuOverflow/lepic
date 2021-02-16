import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/utils/upload_audio.dart';

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
            final audio = await uploadAudio();
            bloc.isAudioAttached
                ? bloc.add(
                    UpdateAudioEvent(
                      oldAudio: bloc.audio,
                      audioData: audio[0],
                      title: bloc.audio.title,
                    ),
                  )
                : bloc.add(
                    CreateAudioEvent(audioData: audio[0], title: audio[1]));
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
}

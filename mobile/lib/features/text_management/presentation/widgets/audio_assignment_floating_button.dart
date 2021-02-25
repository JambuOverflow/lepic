import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_management/domain/entities/audio.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../audio_management/presentation/pages/audio_page.dart';
import '../../../audio_management/presentation/utils/audio_picker.dart';

class AudioAssignmentFloatingButton extends StatelessWidget {
  final GlobalKey parentKey;

  const AudioAssignmentFloatingButton({Key key, @required this.parentKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        showAudioBottomSheet(parentKey.currentContext);

        await showAudioPicker(parentKey.currentContext);
      },
      label: Text('Add Recording'),
      icon: Icon(Icons.music_note),
    );
  }

  void showAudioBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<AudioBloc>(context),
        child: AudioPage(),
      ),
    );
  }

  Future showAudioPicker(BuildContext context) async {
    final pickedFile = await AudioPicker.pick();

    if (pickedFile != null) {
      final audioEntity = AudioPicker.pickerResultToAudioEntity(pickedFile);
      updateOrCreateEvent(audioEntity, context);
    }
  }

  void updateOrCreateEvent(AudioEntity audio, BuildContext context) {
    final bloc = BlocProvider.of<AudioBloc>(context);

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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../../../audio_management/domain/entities/audio.dart';
import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../audio_management/presentation/pages/audio_page.dart';
import '../../../audio_management/presentation/utils/audio_picker.dart';

class AudioAssignmentFloatingButton extends StatefulWidget {
  final GlobalKey parentKey;

  const AudioAssignmentFloatingButton({Key key, @required this.parentKey})
      : super(key: key);

  @override
  _AudioAssignmentFloatingButtonState createState() =>
      _AudioAssignmentFloatingButtonState();
}

class _AudioAssignmentFloatingButtonState
    extends State<AudioAssignmentFloatingButton> {
  PlayerCubit playerCubit;
  AudioBloc audioBloc;

  @override
  void initState() {
    playerCubit = BlocProvider.of<PlayerCubit>(context);
    audioBloc = BlocProvider.of<AudioBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerCubit, PlayerState>(
      listener: (context, state) {
        if (state is PlayerDurationLoaded)
          updateOrCreateEvent(
            playerCubit.currentAudioEntity,
            context,
          );
      },
      child: FloatingActionButton.extended(
        onPressed: () async {
          showAudioBottomSheet(widget.parentKey.currentContext);

          final AudioEntity pickedAudio =
              await showAudioPicker(widget.parentKey.currentContext);

          playerCubit.loadAudio(pickedAudio);
        },
        label: Text('Add Recording'),
        icon: Icon(Icons.music_note),
      ),
    );
  }

  void showAudioBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => BlocProvider.value(
        value: audioBloc,
        child: AudioPage(),
      ),
    );
  }

  Future<AudioEntity> showAudioPicker(BuildContext context) async {
    final pickedFile = await AudioPicker.pick();

    return AudioPicker.pickerResultToAudioEntity(pickedFile);
  }

  void updateOrCreateEvent(AudioEntity audio, BuildContext context) {
    final bloc = BlocProvider.of<AudioBloc>(context);

    final duration = Duration(
      seconds: playerCubit.durationInSeconds.round(),
    );

    bloc.add(
      bloc.isAudioAttached
          ? UpdateAudioEvent(
              oldAudio: bloc.audio,
              audioData: audio.data,
              title: audio.title,
              audioDuration: duration,
            )
          : CreateAudioEvent(
              audioData: audio.data,
              title: audio.title,
              audioDuration: duration,
            ),
    );
  }
}

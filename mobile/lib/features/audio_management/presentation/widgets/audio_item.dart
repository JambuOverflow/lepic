import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/utils/add_or_update_audio.dart';
import 'package:mobile/features/audio_management/presentation/widgets/update_audio_dialog.dart';

class AudioItem extends StatelessWidget {
  final bool dialog;
  final AudioBloc bloc;
  AudioItem({@required this.bloc, @required this.dialog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(bloc.audio.title),
          subtitle: Text('${bloc.student.firstName} ${bloc.student.lastName}'),
          trailing: Icon(Icons.edit),
        ),
      ),
      onTap: () {
        dialog
            ? showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) => UpdateAudioDialog(bloc: bloc),
              )
            : addOrUpdateAudio(bloc);
      },
    );
  }
}

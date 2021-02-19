import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/widgets/update_audio_dialog.dart';

class AudioItem extends StatelessWidget {
  final AudioBloc bloc;
  AudioItem({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(builder: (context, state) {
      return Column(
        children: [
          GestureDetector(
            child: Card(
              child: ListTile(
                title: Text(bloc.audio.title),
                subtitle:
                    Text('${bloc.student.firstName} ${bloc.student.lastName}'),
                trailing: Icon(Icons.edit),
              ),
            ),
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) => UpdateAudioDialog(bloc: bloc),
              );
            },
          ),
          if (bloc.isAudioAttached)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                bloc.add(DeleteAudioEvent());
                Navigator.pop(context);
              },
            ),
        ],
      );
    });
  }
}

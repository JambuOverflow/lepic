import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';

class AudioItem extends StatelessWidget {
  final AudioBloc _bloc;
  AudioItem(this._bloc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
            title: Text(_bloc.audio.title),
            subtitle:
                Text('${_bloc.student.firstName} ${_bloc.student.lastName}'),
            trailing: Icon(Icons.edit)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

class AudioItem extends StatelessWidget {
  final AudioBloc _bloc;
  AudioItem(this._bloc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
            title: Text('${_bloc.student.firstName} ${_bloc.student.lastName}'),
            subtitle: Text(_bloc.audio.title),
            trailing: Icon(Icons.play_arrow_outlined)),
      ),
      // onTap: () => Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: BlocProvider.of<TextBloc>(context),
      //       child: TextDetailPage(_text),
      //     ),
      //   ),
      // ),
    );
  }
}

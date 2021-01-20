import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

class AudioItem extends StatelessWidget {
  final AudioEntity _audio;
  AudioItem(this._audio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
            title: Hero(
              tag: 'body_${_audio.localId}',
              child: Text(
                _audio.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios)),
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

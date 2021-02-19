import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/audio_bloc.dart';
import '../widgets/audio_item.dart';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AudioBloc>(context);
    _bloc.add(LoadAudioEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocConsumer<AudioBloc, AudioState>(
            builder: (context, state) {
              if (state is AudioLoadInProgress)
                return CircularProgressIndicator();
              else if (_bloc.audio == null)
                return ListTile(title: Text('No audio uploaded yet.'));
              else
                return AudioItem(bloc: _bloc);
            },
            listener: (context, state) {
              if (state is Error && _bloc.isAudioAttached)
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            },
          ),
        ],
      ),
    );
  }
}

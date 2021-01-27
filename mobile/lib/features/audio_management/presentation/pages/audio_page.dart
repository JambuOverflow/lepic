import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/utils/add_or_update_audio.dart';
import 'package:mobile/features/audio_management/presentation/widgets/appbar_icon_builder.dart';
import 'package:mobile/features/audio_management/presentation/widgets/audio_item.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key key}) : super(key: key);
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
    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Editing Audio',
        actions: <Widget>[
          BlocBuilder<AudioBloc, AudioState>(
            builder: (context, state) {
              return AppBarIconBuilder(
                bloc: _bloc,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22.0),
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
            SizedBox(height: 20),
            Text(_bloc.text.title, style: TextStyle(fontSize: 24.0)),
            Text(_bloc.text.body),
          ],
        ),
      ),
    );
  }
}

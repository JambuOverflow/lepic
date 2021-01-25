import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/widgets/audio_item.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key key}) : super(key: key);
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioBloc _bloc;
  Uint8List _audioBytes;
  String _path;
  String _fileName;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AudioBloc>(context);
    _bloc.add(LoadAudioEvent());
  }

  void _uploadAudio() async {
    var file =
        (await FilePicker.platform.pickFiles(type: FileType.audio))?.files[0];
    _path = file.path;
    _fileName = file.name;
    _audioBytes = File(_path).readAsBytesSync();
    _bloc.add(CreateAudioEvent(audioData: _audioBytes, title: _fileName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Editing Audio',
        actions: <Widget>[
          BlocBuilder<AudioBloc, AudioState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(_bloc.isAudioAttached
                    ? Icons.delete
                    : Icons.attach_file_sharp),
                onPressed: () {
                  if (_bloc.isAudioAttached) {
                    _bloc.add(DeleteAudioEvent(audio: _bloc.audio));
                    Navigator.pop(context);
                  } else
                    _uploadAudio();
                },
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
                  return Column(children: [AudioItem(_bloc)]);
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

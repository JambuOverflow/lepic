import 'dart:io';
import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AudioBloc>(context);
    _bloc.add(LoadAudioEvent());
  }

  Uint8List _audioBytes;
  String _path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Add audio',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            tooltip: 'Attach audio',
            onPressed: () {
              _uploadAudio();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete record',
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Record/Stop Audio',
        onPressed: () {
          _playAudio();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocConsumer<AudioBloc, AudioState>(
              builder: (context, state) {
                if (state is AudioLoadInProgress)
                  return CircularProgressIndicator();
                else if (_bloc.audio == null) {
                  return Container();
                } else
                  return AudioItem(_bloc.audio);
              },
              listener: (context, state) {
                if (state is Error)
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
              },
            ),
            Text(
              _bloc.text.title,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(_bloc.text.body),
          ],
        ),
      ),
    );
  }

  void _uploadAudio() async {
    try {
      _path = (await FilePicker.platform.pickFiles(type: FileType.audio))
          ?.files[0]
          .path
          .toString();
      _audioBytes = File(_path).readAsBytesSync();
    } on PlatformException catch (e) {
      print('Unsupported' + e.toString());
    }
  }

  void _playAudio() async {
    // https://stackoverflow.com/questions/56044473/how-to-get-bytedata-from-a-file
    // int _ = await _audioPlayer.playBytes(_audioBytes);
    Audio.loadFromByteData(ByteData.view(_audioBytes.buffer))
      ..play()
      ..dispose();
  }
}

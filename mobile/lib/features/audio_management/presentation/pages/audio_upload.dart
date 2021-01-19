import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/audio_management/presentation/widgets/stopwatch.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class AudioPage extends StatefulWidget {
  final MyText text;
  AudioPage({this.text, Key key}) : super(key: key);
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool _recording = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  Uint8List _audio;
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
        child: _recording ? Icon(Icons.stop) : Icon(Icons.play_arrow),
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
            Text(
              widget.text.title,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(widget.text.body),
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
      _audio = File(_path).readAsBytesSync();
      print(_path);
    } on PlatformException catch (e) {
      print('Unsupported' + e.toString());
    }
  }

  void _playAudio() async {
    int _ = await _audioPlayer.play(_path, isLocal: true);
  }
}

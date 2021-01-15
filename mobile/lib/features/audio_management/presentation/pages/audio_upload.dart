// import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/widgets/stopwatch.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class AudioPage extends StatefulWidget {
  final MyText myTextTest;
  AudioPage({this.myTextTest, Key key}) : super(key: key);
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool recording = false;

  StreamSubscription<int> timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.replay),
            tooltip: 'replay recording',
            onPressed: () {
              print('replay recording');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'delete recording',
            onPressed: () {
              print('record deleted');
            },
          ),
        ],
        title: Text('Record audio'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[700],
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
              ),
              Expanded(
                child: Text("$minutesStr:$secondsStr",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Upload the audio file
                  recording
                      ? print('stop the recording first!')
                      : print('audio sended - $minutesStr:$secondsStr');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Begin/stop the audio recording
          setState(() {
            recording = !recording;
            stopWatch();
          });
        },
        child: recording ? Icon(Icons.stop) : Icon(Icons.mic),
        tooltip: 'Record/Stop Audio',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.myTextTest.title,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(widget.myTextTest.body),
          ],
        ),
      ),
    );
  }

  void stopWatch() {
    print("recording: $recording");
    if (recording) {
      Stream<int> timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int newTick) {
        setState(() {
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
      });
    } else {
      timerSubscription.cancel();
      // timerStream = null;
    }
  }
}

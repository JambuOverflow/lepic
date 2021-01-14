// import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/widgets/stopwatch.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool recording = false;

  StreamSubscription<int> timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';

  final MyText myTextTest = new MyText(
      title: 'title',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
      classId: 2);

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
              myTextTest.title,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(myTextTest.body),
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

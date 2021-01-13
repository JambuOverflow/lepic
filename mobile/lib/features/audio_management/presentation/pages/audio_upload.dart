import 'package:flutter/material.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool recording = false;
  final MyText myText = new MyText(
    title: 'title',
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
    classId: 01,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record audio')),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Colors.grey, width: 0.3),
          )),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.replay,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  // restart the recording
                },
              ),
              Expanded(
                child: Text(
                  "",
                ),
              ),
              Wrap(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Upload the audio file
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Begin/stop the audio recording
          setState(() {
            recording = !recording;
          });
          print("recording: $recording");
        },
        child: recording ? Icon(Icons.stop) : Icon(Icons.mic),
        tooltip: 'Upload Audio',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              myText.title,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(myText.body),
          ],
        ),
      ),
    );
  }
}

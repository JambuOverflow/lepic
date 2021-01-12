import 'package:flutter/material.dart';

class AudioPage extends StatefulWidget {
  AudioPage({Key key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool recording = false;

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
                onPressed: () {},
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
                    onPressed: () {},
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
          setState(() {
            recording = !recording;
          });
          print(recording);
        },
        child: recording ? Icon(Icons.stop) : Icon(Icons.mic),
        tooltip: 'Upload Audio',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Text title',
              style: TextStyle(fontSize: 24.0),
            ),
            Text('We move under cover and we move as one'),
            Text('Through the night, we have one shot to live another day'),
            Text('We cannot let a stray gunshot give us away'),
            Text('We will fight up close, seize the moment and stay in it'),
            Text('It’s either that or meet the business end of a bayonet'),
            Text('The code word is ‘Rochambeau,’ dig me?'),
          ],
        ),
      ),
    );
  }
}

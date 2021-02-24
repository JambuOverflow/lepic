import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:path_provider/path_provider.dart';

class LocalAudio extends StatefulWidget {
  final MyText text;

  const LocalAudio(this.text);

  @override
  _LocalAudioState createState() => _LocalAudioState();
}

class _LocalAudioState extends State<LocalAudio> {
  //add the upload file
  final String musicPath = "test_sample.mp3";

  bool playing = false;
  bool firstPlay = true;
  IconData playBtn = Icons.play_circle_filled;

  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Container(
      width: 300,
      child: Slider.adaptive(
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  void back10sec() {
    int value = position.inSeconds.toInt();
    Duration newPos = Duration(seconds: 0);
    if (value - 10 > 0) {
      newPos = Duration(seconds: value - 10);
    }
    _player.seek(newPos);
  }

  void foward10sec() {
    int value = position.inSeconds.toInt();
    int maxValue = musicLength.inSeconds.toInt();
    Duration newPos = Duration(seconds: value);
    if (value + 10 < maxValue) {
      newPos = Duration(seconds: value + 10);
    }
    _player.seek(newPos);
  }

  playLocal() async {
    Uint8List byteData = await (await cache.load(musicPath)).readAsBytes();
    if (firstPlay) {
      firstPlay = !firstPlay;
      await cache.playBytes(byteData);
    } else {
      await _player.resume();
    }
    // Uint8List bytes = await (await cache.load('Music.ogg')).readAsBytes();
    // return bytes;
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play audio'),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            top: 32.0,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    widget.text.title,
                    style: TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    widget.text.body,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 500.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              slider(),
                              Text(
                                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.blue,
                              onPressed: () => back10sec(),
                              icon: Icon(
                                Icons.replay_10,
                              ),
                            ),
                            IconButton(
                              iconSize: 62.0,
                              color: Colors.blue,
                              onPressed: () {
                                if (!playing) {
                                  playLocal();
                                  setState(() {
                                    playBtn = Icons.pause_circle_filled;
                                    playing = true;
                                  });
                                } else {
                                  _player.pause();
                                  setState(() {
                                    playBtn = Icons.play_circle_filled;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(
                                playBtn,
                              ),
                            ),
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.blue,
                              onPressed: () => foward10sec(),
                              icon: Icon(
                                Icons.forward_10_rounded,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

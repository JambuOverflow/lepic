import 'package:flutter/material.dart';

import '../../domain/entities/text.dart';

class WordCountText extends StatelessWidget {
  final MyText text;

  const WordCountText({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Word count: ${text.numberOfWords}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextItemTitle extends StatelessWidget {
  final String title;
  final int subtitle;
  const TextItemTitle({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.blueGrey[900]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: VisualDensity(vertical: -1.5),
            dense: true,
            title: Text(
              '10/08/1999',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            subtitle: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.timelapse, size: 28, color: Colors.white),
          ),
          AudioStatusText(title: 'Audio Status'),
          CorrectionStatusText(title: 'Correction Status'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class AudioStatusText extends StatelessWidget {
  final String title;
  const AudioStatusText({
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15),
        Icon(Icons.mic_none, size: 16, color: Colors.white70),
        SizedBox(width: 6),
        Text(title, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class CorrectionStatusText extends StatelessWidget {
  final String title;
  const CorrectionStatusText({
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15),
        Icon(Icons.rate_review_outlined, size: 16, color: Colors.white70),
        SizedBox(width: 6),
        Text(title, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}

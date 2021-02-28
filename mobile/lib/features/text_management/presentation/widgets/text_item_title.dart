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
      decoration: BoxDecoration(color: Colors.black87),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: VisualDensity(vertical: -2.8),
            dense: true,
            subtitle: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            title: Text(
              'Data',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Icon(
              Icons.timelapse,
              size: 28,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              SizedBox(width: 15),
              Icon(Icons.mic, size: 14, color: Colors.white70),
              SizedBox(width: 5),
              Text('Audio Status', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 15),
              Icon(Icons.rate_review, size: 14, color: Colors.white70),
              SizedBox(width: 5),
              Text('Correction Status',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

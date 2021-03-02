import 'package:flutter/material.dart';

import '../../domain/entities/text.dart';

class TextItemBody extends StatefulWidget {
  final int index;
  final MyText text;
  final Function onTap;

  const TextItemBody({
    Key key,
    @required this.text,
    @required this.index,
    @required this.onTap,
  }) : super(key: key);
  @override
  _TextItemBodyState createState() => _TextItemBodyState();
}

class _TextItemBodyState extends State<TextItemBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: Text('VIEW'),
                onPressed: widget.onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

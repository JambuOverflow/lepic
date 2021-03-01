import 'package:flutter/material.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_area.dart';

class TextItemBody extends StatefulWidget {
  final MyText text;

  const TextItemBody({Key key, @required this.text}) : super(key: key);
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
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                visualDensity: VisualDensity(horizontal: -3, vertical: -3),
                textColor: Colors.black,
                child: Text('View'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

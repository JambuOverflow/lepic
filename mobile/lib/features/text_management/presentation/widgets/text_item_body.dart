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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  // controller: _scrollControler,
                  child: Text(
                    widget.text.body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          FlatButton(
            child: Text('View'),
          ),
        ],
      ),
    );
  }
}

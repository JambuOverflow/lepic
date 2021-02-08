import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/flight_shuttle_builder.dart';

class TextArea extends StatelessWidget {
  final String _textBody;
  final ScrollController _scrollControler;
  final String tag;

  const TextArea({
    Key key,
    @required String textBody,
    @required ScrollController scrollControler,
    @required this.tag,
  })  : _textBody = textBody,
        _scrollControler = scrollControler,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollControler,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
          child: Hero(
            tag: tag,
            child: Text(
              _textBody,
              style: TextStyle(fontSize: 16),
            ),
            flightShuttleBuilder: flightShuttleBuilder,
          ),
        ),
      ),
    );
  }
}

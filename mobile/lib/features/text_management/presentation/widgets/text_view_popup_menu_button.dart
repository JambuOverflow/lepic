import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/text.dart';
import '../bloc/text_bloc.dart';

class TextViewPopupMenuButton extends StatelessWidget {
  final MyText text;

  const TextViewPopupMenuButton({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Delete'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      onSelected: (value) => handleClick(context, value),
    );
  }

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Delete':
        BlocProvider.of<TextBloc>(context).add(DeleteTextEvent(text: text));
        Navigator.pop(context);
        break;
    }
  }
}
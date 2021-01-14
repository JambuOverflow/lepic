import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/pages/audio_upload.dart';

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
        return {'Delete', 'Upload audio'}.map((String choice) {
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
      case 'Upload audio':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<TextBloc>(context),
              child: AudioPage(
                myTextTest: text,
              ),
            ),
          ),
        );
        break;
    }
  }
}

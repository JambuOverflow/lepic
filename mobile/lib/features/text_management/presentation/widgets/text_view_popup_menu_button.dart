import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/pages/audio_page.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

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
        return {'Add audio', 'Delete'}.map((String choice) {
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
      case 'Add audio':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => GetIt.instance<AudioBloc>(
                param1: text,
                // test student entity
                param2: Student(
                  classroomId: 0,
                  firstName: 'vitor',
                  lastName: 'vitinho',
                  id: 1,
                ),
              ),
              child: AudioPage(),
            ),
          ),
        );
        break;
    }
  }
}

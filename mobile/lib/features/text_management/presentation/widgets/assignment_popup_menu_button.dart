import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/single_text_cubit.dart';

import '../bloc/text_bloc.dart';

class AssignmentPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Delete'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (choice == 'Delete')
                  Icon(Icons.delete, color: Theme.of(context).errorColor),
                Text(
                  choice,
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (value) => handleClick(context, value),
    );
  }

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Delete':
        final textBloc = BlocProvider.of<TextBloc>(context);
        int index = BlocProvider.of<SingleTextCubit>(context).assignmentIndex;

        textBloc.add(DeleteTextEvent(text: textBloc.texts[index]));
        Navigator.pop(context);
        break;
    }
  }
}

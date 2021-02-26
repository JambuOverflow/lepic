import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/presentation/bloc/classroom_bloc.dart';
import 'package:mobile/features/class_management/presentation/widgets/update_classroom_dialog.dart';

class ClassroomDetailPopupMenuButton extends StatelessWidget {
  final Classroom classroom;

  const ClassroomDetailPopupMenuButton({
    Key key,
    @required this.classroom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return {'Delete', 'Update'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (choice == 'Delete') Icon(Icons.delete, color: Colors.black),
                if (choice == 'Update') Icon(Icons.edit, color: Colors.black),
                Text(choice),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (value) => handleClick(context, value),
    );
  }

  void handleClick(BuildContext context, String value) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);
    switch (value) {
      case 'Delete':
        bloc.add(DeleteClassroomEvent(classroom: classroom));
        Navigator.pop(context);
        break;
      case 'Update':
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: UpdateClassroomDialog(classroom: classroom),
          ),
        );
        break;
    }
  }
}

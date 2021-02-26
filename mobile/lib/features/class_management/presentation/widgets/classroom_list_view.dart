import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/student_management/presentation/bloc/student_bloc.dart';

import '../bloc/classroom_bloc.dart';
import 'classroom_item.dart';

class ClassroomListView extends StatelessWidget {
  const ClassroomListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClassroomBloc>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bloc.classrooms.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: BlocProvider(
                create: (context) => GetIt.instance<StudentBloc>(
                  param1: bloc.classrooms[index],
                ),
                child: ClassroomItem(index: index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

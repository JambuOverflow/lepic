import 'package:flutter/material.dart';
import 'package:mobile/features/audio_management/presentation/bloc/audio_bloc.dart';
import 'package:mobile/features/audio_management/presentation/widgets/audio_item.dart';

class AudioForm extends StatelessWidget {
  final TextEditingController titleController;
  final AudioBloc bloc;

  const AudioForm({
    Key key,
    @required this.titleController,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Audio title',
            ),
          ),
          SizedBox(height: 16),
          AudioItem(bloc: bloc, dialog: false),
        ],
      ),
    );
  }
}

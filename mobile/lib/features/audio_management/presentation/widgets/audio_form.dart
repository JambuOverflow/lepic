import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';

class AudioForm extends StatelessWidget {
  final TextEditingController titleController;
  final AudioEntity audio;

  const AudioForm({
    Key key,
    @required this.titleController,
    @required this.audio,
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
          ListTile(
            title: Text(audio.title),
            trailing: Icon(
              Icons.edit,
              size: 22,
            ),
            onTap: () => print('Upload new audio'),
          ),
        ],
      ),
    );
  }
}

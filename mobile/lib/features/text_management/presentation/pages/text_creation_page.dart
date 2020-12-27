import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/basic_form.dart';
import '../bloc/text_bloc.dart';

class TextCreationPage extends StatefulWidget {
  @override
  _TextCreationPageState createState() => _TextCreationPageState();
}

class _TextCreationPageState extends State<TextCreationPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New text'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            BasicForm(
              label: 'Title',
              textController: _titleController,
            ),
            BasicForm(
              label: 'Body',
              textController: _bodyController,
            ),
            BlocConsumer<TextBloc, TextState>(
              listener: (context, state) {
                if (state is Error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is Error) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: RaisedButton(
                    child: Text(
                      'Create text',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

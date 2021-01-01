import 'package:flutter/material.dart';

import '../widgets/done_floating_action_button.dart';
import '../widgets/text_body_field.dart';
import '../widgets/text_title_field.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';

class TextEditingPage extends StatelessWidget {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  final _scrollControler = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(title: 'Editing Text'),
      floatingActionButton: DoneFloatingActionButton(),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollControler,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 80),
          child: ListView(
            children: [
              TextTitleField(titleController: _titleController),
              SizedBox(height: 16),
              TextBodyField(textController: _textController),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

import '../widgets/done_floating_action_button.dart';
import '../widgets/text_body_field.dart';
import '../widgets/text_title_field.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';

class TextEditingPage extends StatelessWidget {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  final _scrollControler = ScrollController();

  final MyText textToEdit;

  TextEditingPage({Key key, this.textToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0;

    return Scaffold(
      appBar: BackgroundAppBar(title: 'Editing Text'),
      floatingActionButton: DoneFloatingActionButton(
        onPressed: () {
          if (textToEdit == null) {
            BlocProvider.of<TextBloc>(context).add(
              CreateTextEvent(
                title: _titleController.text,
                body: _textController.text,
              ),
            );
          } else if (textToEdit != null) {
            BlocProvider.of<TextBloc>(context).add(
              UpdateTextEvent(
                title: _titleController.text,
                body: _textController.text,
                oldText: textToEdit,
              ),
            );
          }

          Navigator.of(context).pop();
        },
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollControler,
        child: Padding(
          padding: isKeyboardOpen
              ? const EdgeInsets.fromLTRB(0, 8, 0, 80)
              : const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: TextTitleField(
                  titleController: _titleController,
                  title: textToEdit != null ? textToEdit.title : null,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: TextBodyField(
                  textController: _textController,
                  body: textToEdit != null ? textToEdit.body : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

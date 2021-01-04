import 'package:flutter/material.dart';
import 'package:mobile/features/text_management/presentation/utils/word_section.dart';

class CommentsBottomSheet extends StatelessWidget {
  final String _word;
  final WordSection _section;

  const CommentsBottomSheet({
    Key key,
    @required String wordToComment,
    @required WordSection section,
  })  : _word = wordToComment,
        _section = section,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              buildWordAndDeleteRow(context),
              buildCommentField(),
              SizedBox(height: 16),
              buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildCommentField() {
    return TextField(
      decoration: InputDecoration(hintText: 'Comment'),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
    );
  }

  Row buildWordAndDeleteRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            _word,
            style: TextStyle(fontSize: 22, color: Colors.blue[900]),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Row buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            _section.hasComment = false;
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

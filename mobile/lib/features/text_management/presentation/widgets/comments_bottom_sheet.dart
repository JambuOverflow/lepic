import 'package:flutter/material.dart';

class CommentsBottomSheet extends StatelessWidget {
  final String _word;

  const CommentsBottomSheet({Key key, @required String wordToComment})
      : _word = wordToComment,
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
              buildBottomButtons(),
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
        Icon(Icons.delete, color: Colors.blue),
      ],
    );
  }

  Row buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {},
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {},
        ),
      ],
    );
  }
}

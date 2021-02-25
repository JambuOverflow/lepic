import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_correction/presentation/bloc/correction_bloc.dart';

class CommentsBottomSheet extends StatelessWidget {
  final int _wordIndex;
  final commentaryController = TextEditingController();

  CommentsBottomSheet({
    Key key,
    @required int wordIndex,
  })  : _wordIndex = wordIndex,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);
    commentaryController.text = bloc.indexToMistakes[_wordIndex]?.commentary;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              buildWordAndDeleteRow(context, bloc),
              buildCommentField(),
              SizedBox(height: 16),
              buildBottomButtons(context, bloc),
            ],
          ),
        ),
      ),
    );
  }

  buildCommentField() {
    return TextField(
      controller: commentaryController,
      autofocus: commentaryController.text == '',
      decoration: InputDecoration(hintText: 'Comment'),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
    );
  }

  Row buildWordAndDeleteRow(BuildContext context, CorrectionBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            bloc.indexToWord[_wordIndex],
            style: TextStyle(fontSize: 22, color: Colors.blue[900]),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            bloc.add(RemoveMistakeEvent(wordIndex: _wordIndex));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Row buildBottomButtons(BuildContext context, CorrectionBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            if (commentaryController.text.isNotEmpty)
              bloc.add(CommentEvent(
                wordIndex: _wordIndex,
                commentary: commentaryController.text,
              ));

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

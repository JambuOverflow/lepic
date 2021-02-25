import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/correction_bloc.dart';

class ViewCommentsBottomSheet extends StatelessWidget {
  final int _wordIndex;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  ViewCommentsBottomSheet({
    Key key,
    @required int wordIndex,
  })  : _wordIndex = wordIndex,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);
    textController.text = bloc.indexToMistakes[_wordIndex].commentary;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWordIndicator(bloc),
            SizedBox(height: 16),
            buildTextArea(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Text buildWordIndicator(CorrectionBloc bloc) {
    return Text(
      bloc.indexToWord[_wordIndex],
      style: TextStyle(fontSize: 22, color: Colors.blue[900]),
    );
  }

  Scrollbar buildTextArea() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: scrollController,
      child: TextField(
        readOnly: true,
        controller: textController,
        maxLines: 10,
        minLines: 2,
        decoration: null,
        scrollController: scrollController,
      ),
    );
  }
}

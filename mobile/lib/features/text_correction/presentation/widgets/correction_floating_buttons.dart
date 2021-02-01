import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/correction_bloc.dart';
import '../../../text_management/presentation/widgets/comments_bottom_sheet.dart';

class CorrectionFloatingButtons extends StatelessWidget {
  final int _wordIndex;
  final OverlayEntry _entry;
  final BuildContext ancestorContext;

  CorrectionFloatingButtons({
    Key key,
    @required int wordIndex,
    @required OverlayEntry entry,
    @required this.ancestorContext,
  })  : _wordIndex = wordIndex,
        _entry = entry,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);

    return Material(
      elevation: 9,
      color: Colors.white,
      child: bloc.indexToMistakes[_wordIndex].hasCommentary
          ? Container(
              width: 200,
              child: buildCommentedIcons(bloc, ancestorContext),
            )
          : Container(
              width: 115,
              child: buildHighlightIcons(bloc, ancestorContext),
            ),
    );
  }

  Row buildHighlightIcons(CorrectionBloc bloc, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          color: Theme.of(context).accentColor,
          icon: bloc.indexToMistakes[_wordIndex].hasCommentary
              ? Icon(Icons.mode_comment)
              : Icon(Icons.add_comment),
          tooltip: 'Comment',
          splashRadius: 25,
          onPressed: () {
            _showTextCommentBottomSheet(context, _wordIndex);
            _entry?.remove();
          },
        ),
        Container(
          height: 30,
          child: VerticalDivider(
            color: Colors.grey,
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).accentColor,
          splashRadius: 25,
          tooltip: 'Remove Comment',
          onPressed: () {
            _entry?.remove();
            bloc.add(RemoveMistakeEvent(wordIndex: _wordIndex));
          },
        )
      ],
    );
  }

  buildCommentedIcons(CorrectionBloc bloc, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: ExpandText(
              bloc.indexToMistakes[_wordIndex].commentary,
              style: TextStyle(fontSize: 14),
              arrowColor: Theme.of(context).accentColor,
              arrowPadding: EdgeInsets.zero,
              maxLines: 2,
            ),
          ),
        ),
        Container(
          height: 30,
          child: VerticalDivider(
            color: Colors.grey,
          ),
        ),
        IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.edit),
          tooltip: 'Edit comment',
          splashRadius: 25,
          onPressed: () {
            _showTextCommentBottomSheet(context, _wordIndex);
            _entry?.remove();
          },
        ),
      ],
    );
  }

  void _showTextCommentBottomSheet(BuildContext context, int wordIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CorrectionBloc>(ancestorContext),
        child: CommentsBottomSheet(wordIndex: wordIndex),
      ),
    );
  }
}

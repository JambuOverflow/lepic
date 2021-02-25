import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/correction_bloc.dart';

class CorrectionViewFloatingButtons extends StatelessWidget {
  final int _wordIndex;
  final BuildContext ancestorContext;

  CorrectionViewFloatingButtons({
    Key key,
    @required int wordIndex,
    @required OverlayEntry entry,
    @required this.ancestorContext,
  })  : _wordIndex = wordIndex,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);

    if (bloc.indexToMistakes[_wordIndex] == null) return Container();

    return Material(
        elevation: 9,
        color: Colors.white,
        child: bloc.indexToMistakes[_wordIndex]?.hasCommentary
            ? Container(
                width: 200,
                child: buildCommentedIcons(bloc, ancestorContext),
              )
            : null);
  }

  buildCommentedIcons(CorrectionBloc bloc, BuildContext context) {
    return Expanded(
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
    );
  }
}

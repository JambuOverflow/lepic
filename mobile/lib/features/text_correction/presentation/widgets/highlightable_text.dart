import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/mistake.dart';
import '../bloc/correction_bloc.dart';

class HighlightableText extends StatelessWidget {
  final int index;
  final Function onTap;

  const HighlightableText({
    Key key,
    @required this.index,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);
    final mistake = bloc.indexToMistakes[index];

    return Container(
      child: InkWell(
        onTap: () => onTap(),
        child: Text(
          bloc.indexToWord[index],
          style: TextStyle(
            backgroundColor: _highlightText(mistake),
            decoration: mistake != null && mistake.hasCommentary
                ? TextDecoration.underline
                : null,
            decorationThickness: 1.3,
            fontWeight: FontWeight.w300,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Color _highlightText(Mistake mistake) {
    if (mistake == null) return null;

    if (mistake.hasCommentary)
      return Colors.orange[600];
    else if (mistake.isHighlighted)
      return Colors.amber;
    else
      return null;
  }
}

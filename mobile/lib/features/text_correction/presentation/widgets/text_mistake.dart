import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'correction_positioned_overlay.dart';
import 'highlightable_text.dart';
import '../bloc/correction_bloc.dart';

class TextMistake extends StatefulWidget {
  const TextMistake({Key key}) : super(key: key);

  @override
  _TextMistakeState createState() => _TextMistakeState();
}

class _TextMistakeState extends State<TextMistake> {
  OverlayEntry entry;
  CorrectionBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CorrectionBloc>(context);

    return BlocBuilder<CorrectionBloc, CorrectionState>(
      builder: (_, state) {
        return Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTextSpanWithSplittedText(context),
          ),
        );
      },
    );
  }

  RichText _buildTextSpanWithSplittedText(BuildContext context) {
    final splittedText = bloc.text.splitted;
    final spans = List<TextSpan>();

    for (int i = 0; i < bloc.text.numberOfWords; i++) {
      spans.add(_buildClickableWord(index: i));
      spans.add(_nonClickableSpace());
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: 24, height: 1.25),
      ),
    );
  }

  TextSpan _nonClickableSpace() =>
      TextSpan(text: ' ', style: TextStyle(fontSize: 22));

  TextSpan _buildClickableWord({@required int index}) {
    GlobalKey key = GlobalKey();

    return TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 22),
      children: <InlineSpan>[
        WidgetSpan(
          child: Container(
            child: InkWell(
              onTap: () {
                final mistake = bloc.indexToMistakes[index];
                if (mistake == null) bloc.add(HighlightEvent(wordIndex: index));

                _buildCorrectionOverlay(
                  wordIndex: index,
                  context: context,
                  renderBox: key.currentContext.findRenderObject(),
                );
              },
              child: HighlightableText(index: index, key: key),
            ),
          ),
        ),
      ],
    );
  }

  _buildCorrectionOverlay({
    int wordIndex,
    BuildContext context,
    RenderBox renderBox,
  }) {
    entry = OverlayEntry(
      builder: (_) {
        final offset = renderBox.localToGlobal(
          Offset(renderBox.size.width * 0.25, 0),
        );

        final deviceSize = MediaQuery.of(context).size;
        final horizontalLimit =
            MediaQuery.of(context).orientation == Orientation.portrait
                ? deviceSize.width / 2
                : deviceSize.height * 1.6;

        return CorrectionPositionedOverlay(
          wordIndex: wordIndex,
          entry: entry,
          offset: offset,
          deviceSize: deviceSize,
          horizontalLimit: horizontalLimit,
          parentContext: context,
        );
      },
    );

    Overlay.of(context).insert(entry);
  }
}

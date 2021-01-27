import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../text_correction/presentation/widgets/correction_positioned_overlay.dart';
import '../../../text_correction/presentation/widgets/highlightable_text.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';

class TextMistake extends StatefulWidget {
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
    final text = bloc.text.body;

    final splittedText = text.split(" ");
    final spans = List<TextSpan>();

    for (int i = 0; i <= splittedText.length - 1; i++) {
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
          child: HighlightableText(
            index: index,
            key: key,
            onTap: () {
              if (bloc.indexToMistakes[index] == null)
                bloc.add(HighlightEvent(wordIndex: index));

              _buildCorrectionOverlay(
                wordIndex: index,
                context: context,
                renderBox: key.currentContext.findRenderObject(),
              );
            },
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

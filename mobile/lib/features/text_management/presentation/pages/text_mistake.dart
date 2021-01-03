import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mobile/features/text_management/presentation/widgets/comments_bottom_sheet.dart';

class TextMistake extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextMistakeState();
  }
}

class _TextMistakeState extends State<TextMistake> {
  List<WordSection> _sections;

  String textToSplit =
      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sagittis nulla augue, eget tincidunt massa lobortis ut. Vivamus justo eros, maximus non rutrum et, venenatis id lacus. Suspendisse potenti. Vivamus sit amet dolor nisl. Etiam et nisl ut nibh eleifend suscipit a ac neque. Sed imperdiet orci sed porttitor dignissim.''';

  @override
  void initState() {
    _sections = List<WordSection>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildTextSpanWithSplittedText(textToSplit, context),
      ),
    );
  }

  RichText _buildTextSpanWithSplittedText(
    String textToSplit,
    BuildContext context,
  ) {
    final splittedText = textToSplit.split(" ");
    final spans = List<TextSpan>();

    for (int i = 0; i <= splittedText.length - 1; i++) {
      var tapSection = WordSection(
        longPressCallBack: () {
          _showTextCommentBottomSheet(context, splittedText[i]);
          setState(() {});
        },
        tapCallBack: () {
          print('Text is: ${splittedText[i]} ($i)');
          setState(() {});
        },
      );

      _sections.add(tapSection);
      _addClickableWords(
        spans: spans,
        word: splittedText[i],
        section: _sections[i],
      );
      _addNonClickableSpaces(spans);
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: 22, height: 1.25),
      ),
    );
  }

  void _showTextCommentBottomSheet(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) => CommentsBottomSheet(
        wordToComment: word,
      ),
    );
  }

  void _addClickableWords({
    List<TextSpan> spans,
    String word,
    WordSection section,
  }) {
    spans.add(
      TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
        children: <InlineSpan>[
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                section.isPressed = !section.isPressed;
                return section.tapCallBack();
              },
              onLongPress: () {
                section.isPressed = true;
                section.hasComment = true;
                return section.longPressCallBack();
              },
              child: Text(
                word,
                style: TextStyle(
                  backgroundColor: _highlightText(section),
                  decoration:
                      section.hasComment ? TextDecoration.underline : null,
                  decorationThickness: 1.3,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _highlightText(WordSection section) {
    if (section.hasComment)
      return Colors.orange[600];
    else if (section.isPressed)
      return Colors.amber;
    else
      return null;
  }

  void _addNonClickableSpaces(List<TextSpan> spans) {
    spans.add(TextSpan(
      text: ' ',
      style: TextStyle(fontSize: 22),
    ));
  }
}

class WordSection {
  TapGestureRecognizer tapRecognizer;
  LongPressGestureRecognizer longPressRecognizer;
  bool isPressed = false;
  bool hasComment = false;

  final Function tapCallBack;
  final Function longPressCallBack;

  WordSection({this.tapCallBack, this.longPressCallBack}) {
    longPressRecognizer = LongPressGestureRecognizer();
    tapRecognizer = TapGestureRecognizer();
  }
}

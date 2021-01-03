import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class TextMistake extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextMistakeState();
  }
}

class _TextMistakeState extends State<TextMistake> {
  List<TapSection> sections;

  String textToSplit =
      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sagittis nulla augue, eget tincidunt massa lobortis ut. Vivamus justo eros, maximus non rutrum et, venenatis id lacus. Suspendisse potenti. Vivamus sit amet dolor nisl. Etiam et nisl ut nibh eleifend suscipit a ac neque. Sed imperdiet orci sed porttitor dignissim.''';
  TapGestureRecognizer r1;

  @override
  void initState() {
    sections = List<TapSection>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _buildTextSpanWithSplittedText(textToSplit, context),
    );
  }

  RichText _buildTextSpanWithSplittedText(
    String textToSplit,
    BuildContext context,
  ) {
    final splittedText = textToSplit.split(" ");
    final spans = List<TextSpan>();

    for (int i = 0; i <= splittedText.length - 1; i++) {
      var tapSection = TapSection(callBack: () {
        print('Text is: ${splittedText[i]} ($i)');
        setState(() {});
      });

      sections.add(tapSection);
      _addClickableWords(spans, splittedText, i);
      _addNonClickableSpaces(spans);
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: 22, height: 1.25),
      ),
    );
  }

  void _addClickableWords(
      List<TextSpan> spans, List<String> splittedText, int i) {
    spans.add(
      TextSpan(
        text: splittedText[i].toString(),
        style: TextStyle(
          color: Colors.black,
          backgroundColor: sections[i].isPressed ? Colors.amber : null,
        ),
        recognizer: sections[i].recognizer,
      ),
    );
  }

  void _addNonClickableSpaces(List<TextSpan> spans) {
    spans.add(TextSpan(text: ' '));
  }
}

class TapSection {
  TapGestureRecognizer recognizer;
  bool isPressed = false;
  final Function callBack;

  TapSection({this.callBack}) {
    recognizer = TapGestureRecognizer();
    recognizer.onTap = () {
      this.isPressed = !this.isPressed;
      this.callBack();
    };
  }
}

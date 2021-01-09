import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../utils/word_section.dart';
import '../widgets/comments_bottom_sheet.dart';

class TextMistake extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextMistakeState();
  }
}

class _TextMistakeState extends State<TextMistake> {
  List<WordSection> _sections;

  File _imageFile;
  ScreenshotController _screenshotController = ScreenshotController();

  String testText =
      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam sagittis nulla augue, eget tincidunt massa lobortis ut. Vivamus justo eros, maximus non rutrum et, venenatis id lacus. Suspendisse potenti. Vivamus sit amet dolor nisl. Etiam et nisl ut nibh eleifend suscipit a ac neque. Sed imperdiet orci sed porttitor dignissim.''';

  @override
  void initState() {
    _sections = List<WordSection>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Text Correction',
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async => await _screenshotAndShare(),
          )
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTextSpanWithSplittedText(testText, context),
          ),
        ),
      ),
    );
  }

  Future _screenshotAndShare() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = 'screenshot';
    final path = '$directory/$fileName.png';

    _screenshotController.capture(path: path).then((File image) {
      setState(() {
        _imageFile = image;
        Share.shareFiles([path]);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  RichText _buildTextSpanWithSplittedText(
    String textToSplit,
    BuildContext context,
  ) {
    final splittedText = textToSplit.split(" ");
    final spans = List<TextSpan>();

    for (int i = 0; i <= splittedText.length - 1; i++) {
      var tapSection = WordSection(
        commentFunction: () {
          _showTextCommentBottomSheet(context, splittedText[i], _sections[i]);
          setState(() {});
        },
        highlightFunction: () {
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

  void _showTextCommentBottomSheet(
    BuildContext context,
    String word,
    WordSection section,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) => CommentsBottomSheet(
        wordToComment: word,
        section: section,
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
                if (section.hasComment) return section.commentFunction();

                section.isPressed = !section.isPressed;
                return section.highlightFunction();
              },
              onLongPress: () {
                section.hasComment = true;
                return section.commentFunction();
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

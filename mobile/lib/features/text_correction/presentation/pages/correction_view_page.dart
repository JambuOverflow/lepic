import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/bottom_page_text.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../widgets/view_comments_bottom_sheet.dart';
import '../widgets/highlightable_text.dart';
import '../bloc/correction_bloc.dart';

class CorrectionViewPage extends StatefulWidget {
  @override
  _CorrectionViewPageState createState() => _CorrectionViewPageState();
}

class _CorrectionViewPageState extends State<CorrectionViewPage> {
  OverlayEntry entry;
  CorrectionBloc bloc;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CorrectionBloc>(context);

    return Scaffold(
      appBar: BackgroundAppBar(
        title: 'Correction',
      ),
      body: BlocBuilder<CorrectionBloc, CorrectionState>(
        builder: (_, state) {
          return Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildTextSpanWithSplittedText(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                BottomPageText(text: 'Total Mistakes: ${bloc.mistakes.length}'),
                SizedBox(height: 4),
                BottomPageText(
                    text:
                        'Comments: ${bloc.mistakes.where((e) => e.hasCommentary).length}'),
                SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  RichText _buildTextSpanWithSplittedText(BuildContext context) {
    final text = bloc.text;

    final splittedText = text.splitted;
    final spans = List<TextSpan>();

    for (int i = 0; i <= splittedText.length - 1; i++) {
      spans.add(_buildClickableWord(index: i));
      spans.add(_nonClickableSpace());
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: 20, height: 1.25),
      ),
    );
  }

  TextSpan _nonClickableSpace() =>
      TextSpan(text: ' ', style: TextStyle(fontSize: 20));

  TextSpan _buildClickableWord({@required int index}) {
    GlobalKey key = GlobalKey();

    final mistake = bloc.indexToMistakes[index];
    double fontSize = 20;

    return TextSpan(
      style: TextStyle(color: Colors.black, fontSize: fontSize),
      children: <InlineSpan>[
        mistake != null && mistake.hasCommentary
            ? WidgetSpan(
                child: InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.black.withOpacity(0.25),
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<CorrectionBloc>(context),
                      child: ViewCommentsBottomSheet(wordIndex: index),
                    ),
                  ),
                  child: Container(
                      child: HighlightableText(
                    index: index,
                    key: key,
                    fontSize: fontSize,
                  )),
                ),
              )
            : WidgetSpan(
                child: HighlightableText(
                index: index,
                key: key,
                fontSize: fontSize,
              )),
      ],
    );
  }
}

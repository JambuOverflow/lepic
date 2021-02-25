import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/assignment_status_cubit.dart';
import 'preview_card.dart';
import '../../domain/entities/text.dart';
import '../bloc/text_bloc.dart';
import '../pages/text_detail_page.dart';
import '../pages/text_editing_page.dart';

class TextPreviewCard extends StatefulWidget {
  const TextPreviewCard({Key key, @required MyText text})
      : _text = text,
        super(key: key);

  final MyText _text;

  @override
  _TextPreviewCardState createState() => _TextPreviewCardState();
}

class _TextPreviewCardState extends State<TextPreviewCard> {
  AssignmentStatusCubit statusCubit;

  @override
  void initState() {
    statusCubit = BlocProvider.of<AssignmentStatusCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      title: 'TEXT',
      content: [
        buildTextPreviewArea(),
        buildButtons(),
      ],
    );
  }

  Padding buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
            builder: (context, state) {
              return TextButton(
                child: Text('EDIT'),
                onPressed: statusCubit.hasCorrectionFinished
                    ? null
                    : () =>
                        navigateTo(TextEditingPage(textToEdit: widget._text)),
              );
            },
          ),
          FlatButton(
            child: Text('SEE MORE'),
            onPressed: () => navigateTo(TextDetailPage(widget._text)),
          ),
        ],
      ),
    );
  }

  Padding buildTextPreviewArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.blue[100].withOpacity(0.5),
        highlightColor: Colors.blue[100].withAlpha(0),
        onTap: () => navigateTo(TextDetailPage(widget._text)),
        child: Hero(
          tag: '${widget._text.localId}_body',
          child: Text(
            widget._text.body,
            maxLines: 6,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<TextBloc>(context),
            ),
            BlocProvider.value(value: statusCubit),
          ],
          child: page,
        ),
      ),
    );
  }
}

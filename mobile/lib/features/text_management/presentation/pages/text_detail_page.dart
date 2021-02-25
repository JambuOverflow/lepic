import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/assignment_status_cubit.dart';

import '../widgets/word_count_area.dart';
import '../bloc/text_bloc.dart';
import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../../domain/entities/text.dart';
import '../widgets/text_area.dart';
import 'text_editing_page.dart';

class TextDetailPage extends StatelessWidget {
  final MyText _text;
  final _scrollController = ScrollController();

  TextDetailPage(this._text);

  @override
  Widget build(BuildContext context) {
    final statusCubit = BlocProvider.of<AssignmentStatusCubit>(context);

    return Scaffold(
      appBar: BackgroundAppBar(
        title: '${_text.title}',
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Edit'),
        icon: Icon(Icons.edit),
        backgroundColor: statusCubit.hasCorrectionFinished
            ? Theme.of(context).disabledColor
            : Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: statusCubit.hasCorrectionFinished
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<TextBloc>(context),
                      child: TextEditingPage(textToEdit: _text),
                    ),
                  ),
                ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextArea(
              tag: '${_text.localId}_body',
              textBody: _text.body,
              scrollControler: _scrollController,
            ),
            SizedBox(height: 12),
            WordCountText(text: _text),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

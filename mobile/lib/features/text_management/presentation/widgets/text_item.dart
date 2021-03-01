import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_item_body.dart';
import 'package:mobile/features/text_management/presentation/widgets/text_item_title.dart';

import '../pages/assignment_detail_page.dart';
import '../bloc/text_bloc.dart';

class TextItem extends StatelessWidget {
  final int index;

  const TextItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TextBloc>(context);
    final text = bloc.texts[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        child: GestureDetector(
          child: Column(
            children: [
              TextItemTitle(title: text.title, subtitle: text.numberOfWords),
              TextItemBody(
                text: text,
              ),
            ],
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: AssigmentDetailPage(textIndex: index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

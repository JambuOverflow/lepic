import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return GestureDetector(
      child: Card(
        child: ListTile(
            title: Text(
              text.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Hero(
              tag: 'body_${text.localId}',
              child: Text(
                text.body,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios)),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: AssigmentDetailPage(textIndex: index),
          ),
        ),
      ),
    );
  }
}

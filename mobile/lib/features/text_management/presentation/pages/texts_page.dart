import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/background_app_bar.dart';
import '../bloc/text_bloc.dart';
import '../widgets/text_item.dart';

class TextsPage extends StatefulWidget {
  TextsPage({Key key}) : super(key: key);

  @override
  _TextsPageState createState() => _TextsPageState();
}

class _TextsPageState extends State<TextsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TextBloc>(context).add(GetTextsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<TextBloc>(context);

    return Scaffold(
      appBar: BackgroundAppBar(title: 'Texts'),
      body: BlocConsumer<TextBloc, TextState>(
        builder: (context, state) {
          if (state is TextsLoaded) {
            return ListView.builder(
              itemCount: _bloc.texts.length,
              itemBuilder: (context, index) {
                final text = _bloc.texts[index];
                return TextItem(text);
              },
            );
          } else
            return CircularProgressIndicator();
        },
        listener: (context, state) {
          if (state is Error)
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add_text');
        },
      ),
    );
  }
}

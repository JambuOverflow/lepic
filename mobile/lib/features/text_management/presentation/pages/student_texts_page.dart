import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/empty_list_text.dart';
import '../bloc/text_bloc.dart';
import '../widgets/text_item.dart';
import 'text_editing_page.dart';

class StudentTextsPage extends StatefulWidget {
  StudentTextsPage({Key key}) : super(key: key);

  @override
  _StudentTextsPageState createState() => _StudentTextsPageState();
}

class _StudentTextsPageState extends State<StudentTextsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TextBloc>(context).add(GetTextsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<TextBloc>(context);

    return Scaffold(
      body: BlocConsumer<TextBloc, TextState>(
        builder: (context, state) {
          if (state is TextsLoaded) {
            if (state.texts.isEmpty)
              return EmptyListText(
                'Nothing here 😢 Try creating texts for ${_bloc.student.firstName} to read!',
                fontSize: 16,
              );
            else
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                itemCount: _bloc.texts.length,
                itemBuilder: (context, index) {
                  return TextItem(textIndex: index);
                },
              );
          } else
            return Center(child: CircularProgressIndicator());
        },
        listener: (context, state) {
          if (state is Error)
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Assign Text'),
        icon: Icon(Icons.assignment),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<TextEditingPage>(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<TextBloc>(context),
              child: TextEditingPage(),
            ),
          ),
        ),
      ),
    );
  }
}

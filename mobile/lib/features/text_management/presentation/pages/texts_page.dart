import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

import '../../domain/entities/text.dart';
import 'text_detail_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texts'),
      ),
      body: Center(
        child: BlocListener<TextBloc, TextState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: _blocBuilder(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        elevation: 10,
        onPressed: () => _modalAdd(context: context),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<TextBloc, TextState>(
      builder: (context, state) {
        if (state is GettingTexts) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TextsGot) {
          return Column(
            children: <Widget>[
              Text("Total texts:${state.texts.length}"),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.texts.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.blue,
                      ),
                      child: ListTile(
                        title: Text(
                          '${state.texts[index].title}',
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () => _modalUpdate(
                                text: state.texts[index],
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        BlocProvider.of<TextBloc>(context)
                            .add(DeleteTextEvent(text: state.texts[index]));

                        // Then show a snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "student ${state.texts[index].title} deleted",
                        )));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is Error) {
          return Center(child: Text("Error"));
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'No data',
              ),
            ],
          ),
        );
      },
    );
  }
}

_modalAdd({BuildContext context}) {
  String _title;
  String _body;
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Create new text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  onChanged: (newTitle) => _title = newTitle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  onChanged: (newBody) => _body = newBody,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Body',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                BlocProvider.of<TextBloc>(context).add(CreateTextEvent(
                  classroom: null,
                  body: _body,
                  title: _title,
                ));

                Navigator.pop(context);
              },
              child: Text('Add text'),
            ),
          ],
        );
      });
}

_modalUpdate({MyText text, BuildContext context}) {
  var _title = text.title;
  var _body = text.body;
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit text"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  initialValue: text.title,
                  onChanged: (newTitle) => _title = newTitle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${text.title}',
                  ),
                ),
                TextFormField(
                  initialValue: text.body,
                  onChanged: (newBody) => _body = newBody,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${text.body}',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                BlocProvider.of<TextBloc>(context).add(UpdateTextEvent(
                  body: _body,
                  title: _title,
                  classroom: null,
                  oldText: text,
                ));
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ],
        );
      });
}

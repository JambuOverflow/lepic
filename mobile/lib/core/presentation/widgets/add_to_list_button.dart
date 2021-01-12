import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToListButton<TBloc extends Bloc> extends StatelessWidget {
  const AddToListButton({
    Key key,
    @required TBloc bloc,
    @required Widget dialog,
  })  : _bloc = bloc,
        _child = dialog,
        super(key: key);

  final TBloc _bloc;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      elevation: 10,
      onPressed: () => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => BlocProvider.value(
          value: _bloc,
          child: _child,
        ),
      ),
    );
  }
}

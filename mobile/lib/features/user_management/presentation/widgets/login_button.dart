import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mobile/features/user_management/presentation/bloc/login_form_bloc.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
              child: _loadingOrTextBasedOn(state),
              onPressed: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<LoginFormBloc>(context).add(FormSubmitted());
              }),
        );
      },
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          Navigator.of(context).pushNamed('/home');
        } else if (state.status == FormzStatus.submissionFailure) {
          _showServerFailureSnackBar(context);
        }
      },
    );
  }

  Widget _loadingOrTextBasedOn(LoginFormState state) {
    if (state.status == FormzStatus.submissionInProgress)
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    else
      return Text(
        'Login',
        style: TextStyle(fontSize: 16),
      );
  }

  void _showServerFailureSnackBar(BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Could not reach server'),
      ),
    );
  }
}

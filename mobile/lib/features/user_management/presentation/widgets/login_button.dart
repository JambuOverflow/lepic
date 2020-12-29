import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mobile/features/user_management/presentation/bloc/auth_bloc.dart';

import '../bloc/login_form_bloc.dart';
import '../../../../core/presentation/extensions/snack_bar_extensions.dart';

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
          BlocProvider.of<AuthBloc>(context).add(UserLoggedInEvent());

          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.status == FormzStatus.submissionFailure) {
          Scaffold.of(context).showServerFailureSnackBar(context);
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
}

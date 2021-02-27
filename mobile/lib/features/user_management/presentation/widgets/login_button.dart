import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/login_form_bloc.dart';
import '../../../../core/presentation/extensions/snack_bar_extensions.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, loginState) {
        return MultiBlocListener(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return Container(
                height: 80,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  child: _loadingOrTextBasedOn(loginState, authState),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<LoginFormBloc>(context)
                        .add(FormSubmitted());
                  },
                ),
              );
            },
          ),
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) => _reactToAuthState(state, context),
            ),
            BlocListener<LoginFormBloc, LoginFormState>(
              listener: (context, state) =>
                  _reactToLoginFormState(state, context),
            ),
          ],
        );
      },
    );
  }

  void _reactToAuthState(AuthState state, BuildContext context) {
    if (state.status == AuthStatus.authenticated)
      Navigator.of(context).pushReplacementNamed('home');
  }

  void _reactToLoginFormState(LoginFormState state, BuildContext context) {
    if (state.status == FormzStatus.submissionSuccess)
      BlocProvider.of<AuthBloc>(context).add(UserLoggedInEvent());
    else if (state.status == FormzStatus.submissionFailure)
      Scaffold.of(context).showServerFailureSnackBar(context);
  }

  Widget _loadingOrTextBasedOn(LoginFormState state, AuthState authState) {
    if (state.status == FormzStatus.submissionInProgress ||
        authState.status == AuthStatus.authenticating)
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

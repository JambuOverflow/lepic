import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/signup_form_bloc.dart';

class CreateUserButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupFormBloc, SignupFormState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
          child: RaisedButton(
            child: state.status == FormzStatus.submissionInProgress
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16),
                  ),
            onPressed: () {
              context.read<SignupFormBloc>().add(FormSubmitted());
            },
          ),
        );
      },
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess)
          Navigator.of(context).pushReplacementNamed('/signup_success');
        else if (state.status == FormzStatus.submissionFailure)
          SnackBar(
            content: Text('Submission failed'),
          );
      },
    );
  }
}

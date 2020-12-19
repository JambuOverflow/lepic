import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/validators/email_input.dart';
import 'package:mobile/features/user_management/presentation/bloc/signup_form_bloc.dart';

class EmailInputField extends StatelessWidget {
  final focusNode;

  const EmailInputField({Key key, @required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupFormBloc, SignupFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
            labelText: 'E-mail',
            errorText:
                state.email.invalid ? _errorToText(state.email.error) : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<SignupFormBloc>().add(EmailChanged(email: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  String _errorToText(EmailValidationError error) {
    switch (error) {
      case EmailValidationError.alreadyExists:
        return 'That email is taken. Try another.';
      case EmailValidationError.invalid:
        return 'Please enter a valid email';
      default:
        return 'Something is not right';
    }
  }
}

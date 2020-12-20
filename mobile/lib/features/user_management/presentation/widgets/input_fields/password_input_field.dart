import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/presentation/validators/password_input.dart';

import '../../bloc/user_form_bloc.dart';

class PasswordInputField extends StatelessWidget {
  final focusNode;

  const PasswordInputField({Key key, @required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password.value,
          focusNode: focusNode,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
            labelText: 'Password',
            errorText: state.password.invalid
                ? _errorToText(state.password.error)
                : null,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) => context
              .read<UserFormBloc>()
              .add(PasswordChanged(password: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  String _errorToText(PasswordValidationError error) {
    switch (error) {
      case PasswordValidationError.short:
        return 'Use 8 characters or more for your password';
      case PasswordValidationError.big:
        return 'Use 32 characters or fewer for your password';
      case PasswordValidationError.invalid:
        return '''Please choose a stronger password. Try a mix of upper case letters, 
        lower case letters and numbers''';
      default:
        return 'Something is not right';
    }
  }
}

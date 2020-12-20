import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_form_bloc.dart';

class ConfirmPasswordInputField extends StatelessWidget {
  final focusNode;

  const ConfirmPasswordInputField({Key key, @required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.confirmPassword.value,
          focusNode: focusNode,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
            labelText: 'Confirm Password',
            errorText: state.confirmPassword.invalid
                ? 'Those passwords didn\'t match. Please, try again.'
                : null,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) => context
              .read<UserFormBloc>()
              .add(ConfirmPasswordChanged(confirmPassword: value)),
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

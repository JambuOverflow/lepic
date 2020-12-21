import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/login_form_bloc.dart';

class PasswordLoginInputField extends StatelessWidget {
  const PasswordLoginInputField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_rounded),
            errorText: state.password.invalid ? 'Password is empty' : null,
          ),
          onChanged: (value) => BlocProvider.of<LoginFormBloc>(context)
              .add(PasswordChanged(password: value)),
        );
      },
    );
  }
}

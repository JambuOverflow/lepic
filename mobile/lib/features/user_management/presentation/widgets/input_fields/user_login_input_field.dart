import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/login_form_bloc.dart';

class UserLoginInputField extends StatelessWidget {
  const UserLoginInputField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'E-mail',
            prefixIcon: Icon(Icons.perm_identity_rounded),
            errorText: state.email.invalid ? 'Invalid email' : null,
          ),
          onChanged: (value) => BlocProvider.of<LoginFormBloc>(context)
              .add(EmailChanged(email: value)),
        );
      },
    );
  }
}

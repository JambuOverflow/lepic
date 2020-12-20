import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/user_management/presentation/bloc/user_form_bloc.dart';

class EmailInputField extends StatelessWidget {
  final focusNode;

  const EmailInputField({Key key, @required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
            labelText: 'E-mail',
            errorText:
                state.email.invalid ? 'Please, enter a valid email' : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<UserFormBloc>().add(EmailChanged(email: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

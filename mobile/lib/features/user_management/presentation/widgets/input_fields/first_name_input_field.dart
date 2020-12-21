import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/signup_form_bloc.dart';

class FirstNameInputField extends StatelessWidget {
  final focusNode;

  const FirstNameInputField({Key key, @required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupFormBloc, SignupFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.firstName.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.perm_identity),
            border: OutlineInputBorder(),
            labelText: 'First Name',
            errorText: state.firstName.invalid ? 'Enter first name' : null,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) => context
              .read<SignupFormBloc>()
              .add(FirstNameChanged(firstName: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

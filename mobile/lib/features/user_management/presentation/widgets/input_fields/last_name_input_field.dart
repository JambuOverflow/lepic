import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_form_bloc.dart';

class LastNameInputField extends StatelessWidget {
  final focusNode;

  const LastNameInputField({Key key, @required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupFormBloc, SignupFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.lastName.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.perm_identity),
            border: OutlineInputBorder(),
            labelText: 'Last Name',
            errorText: state.lastName.invalid ? 'Enter last name' : null,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) => context
              .read<SignupFormBloc>()
              .add(LastNameChanged(lastName: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

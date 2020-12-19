import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../bloc/user_form_bloc.dart';

class RoleDropdownInputField extends StatelessWidget {
  final FocusNode focusNode;

  const RoleDropdownInputField({
    Key key,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(builder: (context, state) {
      return DropdownButtonFormField<Role>(
        hint: Text("I am a ..."),
        focusNode: focusNode,
        // value: Role.teacher,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.assignment_ind_outlined),
          border: OutlineInputBorder(),
          errorText: state.role.invalid ? 'Choose your role' : null,
        ),
        onChanged: (Role value) =>
            context.read<UserFormBloc>().add(RoleChanged(role: value)),
        items: [
          DropdownMenuItem(
            child: Text("Teacher"),
            value: Role.teacher,
          ),
          DropdownMenuItem(
            child: Text("Researcher"),
            value: Role.researcher,
          ),
          DropdownMenuItem(
            child: Text("Support Professional"),
            value: Role.support,
          ),
        ],
      );
    });
  }
}

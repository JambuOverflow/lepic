part of 'user_form_bloc.dart';

class UserFormState extends Equatable {
  final NameInput firstName;
  final NameInput lastName;
  final EmailInput email;
  final PasswordInput password;
  final FormzStatus status;

  const UserFormState({
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = FormzStatus.pure,
  });

  UserFormState copyWith({
    final NameInput firstName,
    final NameInput lastName,
    final EmailInput email,
    final PasswordInput password,
    final FormzStatus status,
  }) {
    return UserFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [firstName, lastName, email, password, status];
}

part of 'signup_form_bloc.dart';

class SignupFormState extends Equatable {
  final NameInput firstName;
  final NameInput lastName;
  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final RoleInput role;
  final FormzStatus status;

  const SignupFormState({
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(password: ''),
    this.role = const RoleInput.pure(),
    this.status = FormzStatus.pure,
  });

  SignupFormState copyWith({
    final NameInput firstName,
    final NameInput lastName,
    final EmailInput email,
    final PasswordInput password,
    final ConfirmPasswordInput confirmPassword,
    final RoleInput role,
    final FormzStatus status,
  }) {
    return SignupFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
        role,
        status,
      ];
}

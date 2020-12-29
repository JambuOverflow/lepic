part of 'login_form_bloc.dart';

class LoginFormState extends Equatable {
  final EmailInput email;
  final NotEmptyInput password;
  final FormzStatus status;
  final bool isCredentialInvalid;

  const LoginFormState({
    this.email = const EmailInput.pure(),
    this.password = const NotEmptyInput.pure(),
    this.status = FormzStatus.pure,
    this.isCredentialInvalid = false,
  });

  LoginFormState copyWith({
    final EmailInput email,
    final NotEmptyInput password,
    final FormzStatus status,
    final bool credentialInvalid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isCredentialInvalid: credentialInvalid ?? false,
    );
  }

  @override
  List<Object> get props => [email, password, status, isCredentialInvalid];
}

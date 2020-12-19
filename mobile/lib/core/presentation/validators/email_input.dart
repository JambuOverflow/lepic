import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailValidationError { invalid, alreadyExists }

class EmailInput extends FormzInput<String, EmailValidationError> {
  final bool alreadyExists;

  const EmailInput.pure([String value = '', this.alreadyExists = false])
      : super.pure(value);
  const EmailInput.dirty([String value = '', this.alreadyExists = false])
      : super.dirty(value);

  @override
  EmailValidationError validator(String value) {
    if (alreadyExists) return EmailValidationError.alreadyExists;

    final bool isValid = EmailValidator.validate(value, false, false);

    return isValid ? null : EmailValidationError.invalid;
  }
}

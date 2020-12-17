import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure([String value = '']) : super.pure(value);
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError validator(String value) {
    final bool isValid = EmailValidator.validate(value, false, false);

    return isValid ? null : EmailValidationError.invalid;
  }
}

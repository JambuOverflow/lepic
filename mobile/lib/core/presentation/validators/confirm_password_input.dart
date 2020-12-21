import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { notEqual }

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPasswordInput.pure({@required this.password, String value = ''})
      : super.pure(value);
  const ConfirmPasswordInput.dirty({@required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError validator(String value) {
    if (value != password)
      return ConfirmPasswordValidationError.notEqual;
    else
      return null;
  }
}

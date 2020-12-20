import 'package:formz/formz.dart';

enum PasswordValidationError { short, big, invalid }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  static final _minLenght = 8;
  static final _maxLenght = 32;

  const PasswordInput.pure([String value = '']) : super.pure(value);
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  /// Should be at have 8-32 characters and contain at least:
  /// * One Upper case
  /// * One Lower case
  /// * One Digit
  static final _passwordRegex = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{' +
        ('$_minLenght' + ',' + '$_maxLenght') +
        r'}$',
  );

  @override
  PasswordValidationError validator(String value) {
    if (value.length < _minLenght)
      return PasswordValidationError.short;
    else if (value.length > _maxLenght)
      return PasswordValidationError.big;
    else if (_passwordRegex.hasMatch(value) == false)
      return PasswordValidationError.invalid;
    else
      return null;
  }
}

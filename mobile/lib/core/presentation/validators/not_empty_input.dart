import 'package:formz/formz.dart';

enum NotEmptyValidationError { empty }

class NotEmptyInput extends FormzInput<String, NotEmptyValidationError> {
  const NotEmptyInput.pure([String value = '']) : super.pure(value);
  const NotEmptyInput.dirty([String value = '']) : super.dirty(value);

  @override
  NotEmptyValidationError validator(String value) =>
      value != '' ? null : NotEmptyValidationError.empty;
}

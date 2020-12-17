import 'package:formz/formz.dart';

enum NameValidationError { empty }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure({String value = ''}) : super.pure('');
  const NameInput.dirty(String value) : super.dirty(value);

  @override
  NameValidationError validator(String value) {
    return value.isNotEmpty ? null : NameValidationError.empty;
  }
}

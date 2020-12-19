import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/confirm_password_input.dart';

void main() {
  ConfirmPasswordInput confirmPassword;
  final tPassword = 'ABCdef123@!';

  setUp(() {
    confirmPassword = ConfirmPasswordInput.pure(password: tPassword);
  });

  test('should have pure value as an empty string', () {
    expect(confirmPassword.value, '');
  });

  test('should have pure state when initialized', () {
    expect(confirmPassword.status, FormzInputStatus.pure);
  });

  group('invalid', () {
    test('should return state invalid when not equal to password', () {
      confirmPassword = ConfirmPasswordInput.dirty(
        password: tPassword,
        value: '',
      );

      expect(confirmPassword.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('''should return state valid when equal to password''', () {
      confirmPassword = ConfirmPasswordInput.dirty(
        password: tPassword,
        value: tPassword,
      );

      expect(confirmPassword.status, FormzInputStatus.valid);
    });
  });
}

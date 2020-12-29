import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/email_input.dart';

void main() {
  EmailInput email;

  setUp(() {
    email = EmailInput.pure('');
  });

  test('should have pure value as an empty string', () {
    expect(email.value, '');
  });

  test('should have pure state when initialized', () {
    expect(email.status, FormzInputStatus.pure);
  });
  group('invalid', () {
    test('should return state invalid with plain invalid email', () {
      email = EmailInput.dirty('notanemail');

      expect(email.status, FormzInputStatus.invalid);
    });

    test('should return state invalid with top level invalid email', () {
      email = EmailInput.dirty('email@example');

      expect(email.status, FormzInputStatus.invalid);
    });

    test('should return state invalid with unsupported characters email', () {
      email = EmailInput.dirty('😍👍⁜♪👍😒@example.com');

      expect(email.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('should return state valid with valid email', () {
      email = EmailInput.dirty('vitornovaes.cantao@gmail.com');

      expect(email.status, FormzInputStatus.valid);
    });
  });
}

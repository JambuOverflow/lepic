import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/password_input.dart';

void main() {
  PasswordInput password;

  setUp(() {
    password = PasswordInput.pure();
  });

  test('should have pure value as an empty string', () {
    expect(password.value, '');
  });

  test('should have pure state when initialized', () {
    expect(password.status, FormzInputStatus.pure);
  });
  
  group('invalid', () {
    test('should return state invalid when empty', () {
      password = PasswordInput.dirty('');

      expect(password.status, FormzInputStatus.invalid);
    });

    test('should return state invalid with less than 8 characters', () {
      password = PasswordInput.dirty('abc123!');
      expect(password.status, FormzInputStatus.invalid);

      password = PasswordInput.dirty('ab12');
      expect(password.status, FormzInputStatus.invalid);
    });

    test('should return state invalid with more than 32 characters', () {
      password = PasswordInput.dirty('abc123!a53erSRWgw5371337Yhasd38jl#@&s#7');
      expect(password.status, FormzInputStatus.invalid);
    });

    test('should return state invalid when there is no digits', () {
      password = PasswordInput.dirty('aBc!@deF');

      expect(password.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('''should return state valid with password with at least eight 
    characters and at least one upper case, one lower 
    case and one digit''', () {
      password = PasswordInput.dirty('Ab32!dE%ky');

      expect(password.status, FormzInputStatus.valid);
    });
  });
}

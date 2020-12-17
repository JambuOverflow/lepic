import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/name_input.dart';

void main() {
  NameInput name;

  setUp(() {
    name = NameInput.pure();
  });

  test('should have pure value as an empty string', () {
    expect(name.value, '');
  });

  test('should have pure state when initialized', () {
    expect(name.status, FormzInputStatus.pure);
  });
  group('invalid', () {
    test('should return state invalid when empty', () {
      name = NameInput.dirty('');

      expect(name.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('should return state valid with any name', () {
      name = NameInput.dirty('Vitor');
      expect(name.status, FormzInputStatus.valid);

      name = NameInput.dirty('12512');
      expect(name.status, FormzInputStatus.valid);

      name = NameInput.dirty('AS24as@o!');
      expect(name.status, FormzInputStatus.valid);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/not_empty_input.dart';

void main() {
  NotEmptyInput input;

  setUp(() {
    input = NotEmptyInput.pure();
  });

  test('should have pure value as an empty string', () {
    expect(input.value, '');
  });

  test('should have pure state when initialized', () {
    expect(input.status, FormzInputStatus.pure);
  });
  group('invalid', () {
    test('should return state invalid with dirty empty string', () {
      input = NotEmptyInput.dirty('');

      expect(input.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('should return state valid when not empty', () {
      input = NotEmptyInput.dirty('gAsin231%@');

      expect(input.status, FormzInputStatus.valid);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mobile/core/presentation/validators/role_input.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

void main() {
  RoleInput role;

  setUp(() {
    role = RoleInput.pure();
  });

  test('should have pure value as null', () {
    expect(role.value, null);
  });

  test('should have pure state when initialized', () {
    expect(role.status, FormzInputStatus.pure);
  });

  group('invalid', () {
    test('should return state invalid when null', () {
      role = RoleInput.dirty();

      expect(role.status, FormzInputStatus.invalid);
    });
  });

  group('valid', () {
    test('''should return state valid when assigned a valid role''', () {
      role = RoleInput.dirty(Role.support);

      expect(role.status, FormzInputStatus.valid);
    });
  });
}

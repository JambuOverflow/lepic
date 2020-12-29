import 'package:formz/formz.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

enum RoleValidationError { notSelected }

class RoleInput extends FormzInput<Role, RoleValidationError> {
  const RoleInput.pure([Role value]) : super.pure(value);
  const RoleInput.dirty([Role value]) : super.dirty(value);

  @override
  RoleValidationError validator(Role value) =>
      value != null ? null : RoleValidationError.notSelected;
}

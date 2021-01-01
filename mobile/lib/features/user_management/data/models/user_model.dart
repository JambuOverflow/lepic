import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

class UserModels extends Table {
  IntColumn get id => integer().autoIncrement()();
  @JsonKey('first_name')
  TextColumn get firstName => text()();
  @JsonKey('last_name')
  TextColumn get lastName => text()();
  TextColumn get email => text()();
  TextColumn get username => text()();
  IntColumn get role => intEnum<Role>()();
  TextColumn get password => text()();
}

UserModel userEntityToModel(User entity) {
  return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      username: entity.email,
      role: entity.role,
      password: entity.password);
}

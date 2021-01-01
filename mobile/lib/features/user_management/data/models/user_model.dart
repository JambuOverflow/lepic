import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/moor.dart';

class UserSerializer extends ValueSerializer {
  @override
  T fromJson<T>(json) {
    if (T == Role)
      return Role.values[json] as T;
    else if (json == 'set to null')
      return null;
    else
      return json as T;
  }

  @override
  toJson<T>(T value) {
    if (T == Role)
      return (value as Role).index;
    else if (value == null)
      return 'set to null';
    else
      return value;
  }
}

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

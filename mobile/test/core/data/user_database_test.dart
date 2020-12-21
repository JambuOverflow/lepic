import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';

void main() {
  Database database;
  VmDatabase vmDatabase;

  final tValidPrimaryKey = 1;

  final tUserModel = UserModel(
    localId: 1,
    firstName: 'v',
    lastName: 'c',
    email: 'v@g.com',
    username: 'v@g.com',
    role: Role.teacher,
    password: '123',
  );

  final tUpdatedUserModel = UserModel(
    localId: 1,
    firstName: 'v',
    lastName: 's',
    email: 'vs@g.com',
    username: 'vs@g.com',
    role: Role.researcher,
    password: '1234',
  );

  setUp(() {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database.customExecutor(vmDatabase);
  });

  tearDown(() async {
    await database.close();
  });

  test('should return the primary key of a valid user when inserted', () async {
    final primaryKey = await database.insertUser(tUserModel);

    expect(primaryKey, tValidPrimaryKey);
  });

  test('should update user that is already present in the database', () async {
    final primaryKey = await database.insertUser(tUserModel);
    await database.updateUser(tUpdatedUserModel);

    final actual = await database.userById(primaryKey);

    expect(actual, tUpdatedUserModel);
  });
}

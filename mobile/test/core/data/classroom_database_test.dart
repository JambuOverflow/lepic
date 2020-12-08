import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

Future<void> main() {
  final tValidPk = 1;
  final tValidClassCompanion = ClassroomModelsCompanion(
      grade: Value(1), name: Value("A"), tutorId: Value(1));

  final tInvalidClassCompanion = ClassroomModelsCompanion(
      grade: Value(1), name: Value("A"), tutorId: Value(2));

  final tUserCompanion = UserModelsCompanion(
    firstName: Value("cana"),
    lastName: Value("varro"),
    email: Value("dede@.com"),
    role: Value(Role.teacher),
    password: Value("1234"),
  );

  Database database;
  VmDatabase vmDatabase;

  setUp(() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    database.into(database.userModels).insert(tUserCompanion);
  });

  test("should return the pk of a valid classroom when inserted", () async {
    final pk = await database
        .into(database.classroomModels)
        .insert(tValidClassCompanion);

    expect(pk, tValidPk);
  });

  test("should return a SQLite error", () async {
    expect(
        () => database
            .into(database.classroomModels)
            .insert(tInvalidClassCompanion),
        throwsA(TypeMatcher<SqliteException>()));
  });

  tearDown(() async {
    await database.close();
  });
}

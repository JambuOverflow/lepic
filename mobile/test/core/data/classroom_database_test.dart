import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidClassroomPk1 = 1;
  final tValidClassroomPk2 = 2;
  final tInvalidClassroomPk = 2;
  final tValidUserPk = 1;
  final tInvalidUserPk = 2;
  final grade = 1;
  final name = "A";
  final updateName = "B";

  final tValidClassCompanion = ClassroomModelsCompanion(
      grade: Value(grade), name: Value(name), tutorId: Value(tValidUserPk));

  final tInvalidClassCompanion = ClassroomModelsCompanion(
      grade: Value(grade), name: Value(name), tutorId: Value(tInvalidUserPk));

  final tValidClassModel1 = ClassroomModel(
      grade: grade,
      name: name,
      tutorId: tValidUserPk,
      localId: tValidClassroomPk1);

  final tValidClassModel2 = ClassroomModel(
      grade: grade,
      name: name,
      tutorId: tValidUserPk,
      localId: tValidClassroomPk2);

  final tValidUpdateClassModel = ClassroomModel(
      grade: grade,
      name: updateName,
      tutorId: tValidUserPk,
      localId: tValidClassroomPk1);

  final tInvalidUpdateClassModel = ClassroomModel(
      localId: tInvalidClassroomPk,
      grade: grade,
      name: updateName,
      tutorId: tValidUserPk);

  final tUserCompanion = UserModelsCompanion(
    firstName: Value("cana"),
    lastName: Value("varro"),
    email: Value("dede@.com"),
    role: Value(Role.teacher),
    password: Value("1234"),
  );

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    await database.into(database.userModels).insert(tUserCompanion);
  }

  setUp(() async {
    await connectDatabase();
  });

  tearDown(() async {
    await closeDatabase(database);
  });

  group("insertClassroom", () {
    test("should return the pk of a valid classroom when inserted", () async {
      final pk = await database.insertClassroom(tValidClassCompanion);

      expect(pk, tValidClassroomPk1);
    });

    test("should return a SQLite error", () async {
      expect(() => database.insertClassroom(tInvalidClassCompanion),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteClassroom", () {
    setUp(() async {
      await database.insertClassroom(tValidClassCompanion);
    });

    test(
        "should return 1 indicating that a row was deleted when the input is a valid pk",
        () async {
      final deleted = await database.deleteClassroom(tValidClassroomPk1);
      expect(deleted, 1);
    });

    test(
        "should return 0 indicating that no rows were deleted when the input is an invalid pk",
        () async {
      final deleted = await database.deleteClassroom(tInvalidClassroomPk);
      expect(deleted, 0);
    });
  });

  group("getClassrooms", () {

    test("should return an empty list of classrooms", () async {
      final classrooms = await database.getClassrooms(tValidUserPk);
      expect(classrooms, []);
    });

    test("should return a list with one classroom", () async {
      await database.insertClassroom(tValidClassCompanion);

      final classrooms = await database.getClassrooms(tValidUserPk);
      expect(classrooms, [tValidClassModel1]);
    });

    test("should return a list with two classrooms", () async {
      await database.insertClassroom(tValidClassCompanion);
      await database.insertClassroom(tValidClassCompanion);

      final classrooms = await database.getClassrooms(tValidUserPk);
      expect(classrooms, [tValidClassModel1, tValidClassModel2]);
    });
  });

  group("getClassrooms", () {
    setUp(() async {
      await database.insertClassroom(tValidClassCompanion);
    });

    test("should return true when updating a valid classroom", () async {
      final done = await database.updateClassroom(tValidUpdateClassModel);
      expect(done, true);
    });

    test("should return false when updating an invalid classroom", () async {
      final done = await database.updateClassroom(tInvalidUpdateClassModel);
      expect(done, false);
    });
  });
}

Future closeDatabase(Database database) async {
  await database.close();
}

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
  final grade = 1;
  final name = "A";
  final updateName = "B";

  final tValidClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    name: Value(name),
    tutorId: Value(tValidUserPk),
    deleted: Value(false),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
  );

  final tDeletedClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    name: Value(name),
    tutorId: Value(tValidUserPk),
    deleted: Value(true),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
  );

  // No User
  final tInvalidClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    name: Value(name),
    deleted: Value(false),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
  );

  final tValidClassModel1 = ClassroomModel(
    grade: grade,
    name: name,
    tutorId: tValidUserPk,
    localId: tValidClassroomPk1,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
  );

  final tValidClassModel2 = ClassroomModel(
    grade: grade,
    name: name,
    tutorId: tValidUserPk,
    localId: tValidClassroomPk2,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
  );

  final tValidUpdateClassModel = ClassroomModel(
      grade: grade,
      name: updateName,
      tutorId: tValidUserPk,
      localId: tValidClassroomPk1,
      deleted: false,
      lastUpdated: DateTime(2020),
      clientLastUpdated: DateTime(2020));

  final tInvalidUpdateClassModel = ClassroomModel(
    localId: tInvalidClassroomPk,
    grade: grade,
    name: updateName,
    tutorId: tValidUserPk,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
  );

  final tUserCompanion = UserModelsCompanion(
    firstName: Value("cana"),
    lastName: Value("varro"),
    email: Value("dede@.com"),
    username: Value("dede@.com"),
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

    test("should return a SQLite error when tutorID is absent", () async {
      expect(() => database.insertClassroom(tInvalidClassCompanion),
          throwsA(TypeMatcher<InvalidDataException>()));
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

    test("should return a list with one valid classroom", () async {
      await database.insertClassroom(tValidClassCompanion);
      await database.insertClassroom(tDeletedClassCompanion);

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

  group("UpdateClassroom", () {
    setUp(() async {
      await database.insertClassroom(tValidClassCompanion);
    });

    test("should return nothing when updating a valid classroom", () async {
      await database.updateClassroom(tValidUpdateClassModel);
    });

    test("should throw a SqlException when updating an invalid classroom",
        () async {
      expect(() => database.updateClassroom(tInvalidUpdateClassModel),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("classroomExists", () {
    setUp(() async {
      await database.insertClassroom(tValidClassCompanion);
    });

    test("should return true when the class exists", () async {
      final result = await database.classroomExists(tValidClassroomPk1);
      expect(result, true);
    });

    test("should return false when the class doesn't exist", () async {
      final result = await database.classroomExists(tInvalidClassroomPk);
      expect(result, false);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidStudentPk1 = 1;
  final tValidStudentPk2 = 2;
  final tInvalidStudentPk = 3;

  final tValidClassroomPk = 1;
  final tInvalidClassroomPk = 2;

  final firstName = "A";
  final lastName = "B";
  final updateFirstName = "C";

  final tValidStudentCompanion = StudentModelsCompanion(
      classroomId: Value(tValidClassroomPk),
      firstName: Value(firstName),
      lastName: Value(lastName));

  final tInvalidStudentCompanion = StudentModelsCompanion(
      classroomId: Value(tInvalidClassroomPk),
      firstName: Value(firstName),
      lastName: Value(lastName));

  final tValidStudentModel1 = StudentModel(
      classroomId: tValidClassroomPk,
      firstName: firstName,
      lastName: lastName,
      localId: tValidStudentPk1);

  final tValidStudentModel2 = StudentModel(
      classroomId: tValidClassroomPk,
      firstName: firstName,
      lastName: lastName,
      localId: tValidStudentPk2);

  final tValidUpdateStudentModel = StudentModel(
      classroomId: tValidClassroomPk,
      firstName: updateFirstName,
      lastName: lastName,
      localId: tValidStudentPk1);

  final tInvalidUpdateStudentModel = StudentModel(
      classroomId: tValidClassroomPk,
      firstName: updateFirstName,
      lastName: lastName,
      localId: tInvalidStudentPk);

  final tClassCompanion = ClassroomModelsCompanion(
    name: Value("A"),
    grade: Value(1),
    tutorId: Value(1),
    lastUpdated: Value(DateTime.now()),
    clientLastUpdated: Value(DateTime.now()),
    deleted: Value(false),
  );

  final tUserCompanion = UserModelsCompanion(
    firstName: Value('v'),
    lastName: Value('c'),
    email: Value('v@g.com'),
    username: Value('v@g.com'),
    role: Value(Role.teacher),
    password: Value('123'),
  );

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    await database.into(database.userModels).insert(tUserCompanion);
    await database.into(database.classroomModels).insert(tClassCompanion);
  }

  setUp(() async {
    await connectDatabase();
  });

  tearDown(() async {
    await closeDatabase(database);
  });

  group("insertStudent", () {
    test("should return the pk of a valid student when inserted", () async {
      final pk = await database.insertStudent(tValidStudentCompanion);
      expect(pk, tValidStudentPk1);
    });

    test("should return a SQLite error", () async {
      expect(() => database.insertStudent(tInvalidStudentCompanion),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteStudent", () {
    setUp(() async {
      await database.insertStudent(tValidStudentCompanion);
    });

    test(
        "should return 1 indicating that a row was deleted when the input is a valid pk",
        () async {
      final deleted = await database.deleteStudent(tValidStudentPk1);
      expect(deleted, 1);
    });

    test(
        "should return 0 indicating that no rows were deleted when the input is an invalid pk",
        () async {
      final deleted = await database.deleteStudent(tInvalidStudentPk);
      expect(deleted, 0);
    });
  });

  group("getStudents", () {
    test("should return an empty list of students", () async {
      final students = await database.getStudents(tValidClassroomPk);
      expect(students, []);
    });

    test("should return a list with one student", () async {
      await database.insertStudent(tValidStudentCompanion);

      final students = await database.getStudents(tValidClassroomPk);
      expect(students, [tValidStudentModel1]);
    });

    test("should return a list with two students", () async {
      await database.insertStudent(tValidStudentCompanion);
      await database.insertStudent(tValidStudentCompanion);

      final students = await database.getStudents(tValidClassroomPk);
      expect(students, [tValidStudentModel1, tValidStudentModel2]);
    });
  });

  group("getStudents", () {
    setUp(() async {
      await database.insertStudent(tValidStudentCompanion);
    });

    test("should return true when updating a valid student", () async {
      final done = await database.updateStudent(tValidUpdateStudentModel);
      expect(done, true);
    });

    test("should return false when updating an invalid student", () async {
      final done = await database.updateStudent(tInvalidUpdateStudentModel);
      expect(done, false);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidMistakePk1 = 1;
  final tValidMistakePk2 = 2;
  final tInvalidMistakePk = 3;

  final tValidTextPk = 1;
  final tInvalidTextPk = 2;

  final tValidStudentPk = 1;
  final tInvalidStudentPk = 2;

  final firstName = "A";
  final lastName = "B";
  final updateFirstName = "C";

  final tValidMistakeModelInput = MistakeModel(
    commentary: "",
    wordIndex: 1,
    textId: tValidTextPk,
    studentId: tValidStudentPk,
  );

  final tClassroomCompanion = ClassroomModelsCompanion(
    name: Value("A"),
    grade: Value(1),
    tutorId: Value(1),
    lastUpdated: Value(DateTime(0)),
    clientLastUpdated: Value(DateTime(0)),
    deleted: Value(false),
  );

  final tStudentCompanion = StudentModelsCompanion(
    firstName: Value(""),
    lastName: Value(""),
    classroomId: Value(1),
  );

  final tTextCompanion = TextModelsCompanion(
    body: Value(""),
    title: Value(""),
    tutorId: Value(1),
    classId: Value(1),
  );

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    await database.into(database.classroomModels).insert(tClassroomCompanion);
    await database.into(database.studentModels).insert(tStudentCompanion);
    await database.into(database.textModels).insert(tTextCompanion);
  }

  setUp(() async {
    await connectDatabase();
  });

  tearDown(() async {
    await closeDatabase(database);
  });

  group("insertMistake", () {
    test("should return the pk of a valid mistake when inserted", () async {
      final pk = await database.insertMistake(tValidMistakeModelInput);
      expect(pk, tValidMistakePk1);
    });

    test("should return a SQLite error if student pk is invalid", () async {
      expect(
          () => database
              .insertMistake(tValidMistakeModelInput.copyWith(studentId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });

    test("should return a SQLite error if text pk is invalid", () async {
      expect(
          () => database
              .insertMistake(tValidMistakeModelInput.copyWith(textId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteMistake", () {
    setUp(() async {
      await database.insertMistake(tValidMistakeModelInput);
    });

    test("should run without throwing an exception", () async {
      await database.deleteMistakesOfCorrection(textPk: 1, studentPk: 1);

      final result = await database.getAllMistakes();

      expect(result, []);
    });

    test("""should throw an exception when the database does not contain
         mistakes with the textPk passed""", () async {
      expect(() => database.deleteMistakesOfCorrection(textPk: 2, studentPk: 1),
          throwsA(TypeMatcher<SqliteException>()));
    });

    test("""should throw an exception when the database does not contain
         mistakes with the studentPk passed""", () async {
      expect(() => database.deleteMistakesOfCorrection(textPk: 1, studentPk: 2),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("getMistakes", () {
    test("should return an empty list of mistakes", () async {
      final mistakes =
          await database.getMistakesOfCorrection(studentPk: 1, textPk: 1);
      expect(mistakes, []);
    });

    test("should return a list with one mistake", () async {
      await database.insertMistake(tValidMistakeModelInput);

      final mistakes =
          await database.getMistakesOfCorrection(studentPk: 1, textPk: 1);
      expect(mistakes, [tValidMistakeModelInput.copyWith(localId: 1)]);
    });

    test("should return a list with two mistakes", () async {
      await database.insertMistake(tValidMistakeModelInput);
      await database.insertMistake(tValidMistakeModelInput);

      final mistakes =
          await database.getMistakesOfCorrection(studentPk: 1, textPk: 1);
      expect(mistakes, [
        tValidMistakeModelInput.copyWith(localId: 1),
        tValidMistakeModelInput.copyWith(localId: 2),
      ]);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

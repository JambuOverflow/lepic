import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidMistakePk1 = 1;
  final tValidTextPk = 1;
  final tValidStudentPk = 1;

  final tValidMistakeModelInput = MistakeModel(
    commentary: "",
    wordIndex: 1,
    correctionId: 1,
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
    studentId: Value(1),
  );

  final tCorrectionModel = CorrectionModel(studentId: 1, textId: 1);

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

  group("insertCorrection", () {
    test("should return the pk of a valid mistake when dinserted", () async {
      final pk = await database.insertCorrection(tCorrectionModel);
      expect(pk, tValidMistakePk1);
    });

    test("should return a SQLite error if student pk is invalid", () async {
      expect(
          () => database
              .insertCorrection(tCorrectionModel.copyWith(studentId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });

    test("should return a SQLite error if text pk is invalid", () async {
      expect(
          () => database.insertCorrection(tCorrectionModel.copyWith(textId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("insertMistake", () {
    setUp(() async {
      await database.insertCorrection(tCorrectionModel);
    });

    test("should return the pk of a valid mistake when dinserted", () async {
      final pk = await database.insertMistake(tValidMistakeModelInput);
      expect(pk, tValidMistakePk1);
    });

    test("should return a SQLite error if student pk is invalid", () async {
      expect(
          () => database
              .insertMistake(tValidMistakeModelInput.copyWith(correctionId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteMistake", () {
    setUp(() async {
      await database.insertCorrection(tCorrectionModel);
      await database.insertMistake(tValidMistakeModelInput);
    });

    test("should run without throwing an exception", () async {
      await database.deleteCorrectionMistakes(1);

      final result = await database.getAllMistakes();

      expect(result, []);
    });

    test("""should throw an exception when the database does not contain
         mistakes with the correctionPk passed""", () async {
      expect(() => database.deleteCorrectionMistakes(2),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteCorrection", () {
    setUp(() async {
      await database.insertCorrection(tCorrectionModel);
    });

    test("should run without throwing an exception", () async {
      await database.deleteCorrection(1);

      final result = await database.getAllMistakes();

      expect(result, []);
    });

    test("""should throw an exception when the database does not contain
         mistakes with the correctionPk passed""", () async {
      expect(() => database.deleteCorrection(2),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("getMistakes", () {
    setUp(() async {
      await database.insertCorrection(tCorrectionModel);
    });
    test("should return an empty list of mistakes", () async {
      final mistakes = await database.getMistakesOfCorrection(1);
      expect(mistakes, []);
    });

    test("should return a list with one mistake", () async {
      await database.insertMistake(tValidMistakeModelInput);

      final mistakes = await database.getMistakesOfCorrection(1);
      expect(mistakes, [tValidMistakeModelInput.copyWith(localId: 1)]);
    });

    test("should return a list with two mistakes", () async {
      await database.insertMistake(tValidMistakeModelInput);
      await database.insertMistake(tValidMistakeModelInput);

      final mistakes = await database.getMistakesOfCorrection(1);
      expect(mistakes, [
        tValidMistakeModelInput.copyWith(localId: 1),
        tValidMistakeModelInput.copyWith(localId: 2),
      ]);
    });
  });

  group("getCorrection", () {
    setUp(() async {
      await database.insertCorrection(tCorrectionModel);
    });
    test("should return a correction", () async {
      final mistakes = await database.getCorrection(studentId: 1, textId: 1);
      expect(mistakes, tCorrectionModel.copyWith(localId: 1));
    });

    test("""should throw an exception when the database does not contain
         mistakes with the correctionPk passed""", () async {
      expect(() => database.getCorrection(studentId: 2, textId: 2),
          throwsA(TypeMatcher<EmptyDataException>()));
    });

   
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

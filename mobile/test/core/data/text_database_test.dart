import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidTextPk1 = 1;
  final tValidTextPk2 = 2;
  final tInvalidTextPk = 3;

  final tValidStudentPk = 1;
  final tInvalidStudentPk = 2;

  final title = "A";
  final updateBody = "C";
  final body = "B";

  final tValidTextCompanion = TextModelsCompanion(
    title: Value(title),
    body: Value(body),
    studentId: Value(tValidStudentPk),
    tutorId: Value(1),
    creationDate: Value(DateTime(2020))
  );

  final tInvalidTextCompanion = TextModelsCompanion(
    title: Value(title),
    body: Value(body),
    studentId: Value(tInvalidStudentPk),
    tutorId: Value(2),
    creationDate: Value(DateTime(2020))

  );

  final tValidTextModel1 = TextModel(
    title: title,
    body: body,
    studentId: tValidStudentPk,
    localId: tValidTextPk1,
    tutorId: 1,
    creationDate: DateTime(2020),

  );

  final tValidTextModel2 = TextModel(
    title: title,
    body: body,
    studentId: tValidStudentPk,
    localId: tValidTextPk2,
    tutorId: 1,
    creationDate: DateTime(2020),

  );

  final tUserCompanion = UserModelsCompanion(
    firstName: Value('v'),
    lastName: Value('c'),
    email: Value('v@g.com'),
    username: Value('v@g.com'),
    role: Value(Role.teacher),
    password: Value('123'),
  );

  final tClassroomCompanion = ClassroomModelsCompanion(
    grade: Value(1),
    name: Value("varro"),
    tutorId: Value(1),
    lastUpdated: Value(DateTime.now()),
    clientLastUpdated: Value(DateTime.now()),
    deleted: Value(false),
  );

  final tStudentCompanion = StudentModelsCompanion(
    classroomId: Value(1),
    firstName: Value('a'),
    lastName: Value('b'),
  );

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);

    await database.into(database.userModels).insert(tUserCompanion);
    await database.into(database.classroomModels).insert(tClassroomCompanion);
    await database.into(database.studentModels).insert(tStudentCompanion);
  }

  setUp(() async {
    await connectDatabase();
  });

  tearDown(() async {
    await closeDatabase(database);
  });

  group("insertText", () {
    test("should return the pk of a valid text when inserted", () async {
      final pk = await database.insertText(tValidTextCompanion);

      expect(pk, tValidTextPk1);
    });

    test("should return a SQLite error", () async {
      expect(() => database.insertText(tInvalidTextCompanion),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteText", () {
    setUp(() async {
      await database.insertText(tValidTextCompanion);
    });

    test("shouldn't throw an exception when the input is a valid pk", () async {
      await database.deleteText(tValidTextPk1);
      equals(true);
    });

    test("should throw an exception when the input is an invalid pk", () async {
      expect(() => database.deleteText(tInvalidTextPk),
          throwsA(const TypeMatcher<SqliteException>()));
    });
  });

  group("getTextsOfClassroom", () {
    test("should return an empty list of texts", () async {
      final texts = await database.getStudentTexts(tValidStudentPk);
      expect(texts, []);
    });

    test("should return a list with one text", () async {
      await database.insertText(tValidTextCompanion);

      final texts = await database.getStudentTexts(tValidStudentPk);
      expect(texts, [tValidTextModel1]);
    });

    test("should return a list with two texts", () async {
      await database.insertText(tValidTextCompanion);
      await database.insertText(tValidTextCompanion);

      final texts = await database.getStudentTexts(tValidStudentPk);
      expect(texts, [tValidTextModel1, tValidTextModel2]);
    });
  });

  group("getTexts", () {
    test("should return an empty list of texts", () async {
      final texts = await database.getAllTextsOfUser(1);
      expect(texts, []);
    });

    test("should return a list with one text", () async {
      await database.insertText(tValidTextCompanion);

      final texts = await database.getAllTextsOfUser(1);
      expect(texts, [tValidTextModel1]);
    });

    test("should return a list with two texts", () async {
      await database.insertText(tValidTextCompanion);
      await database.insertText(tValidTextCompanion);

      final texts = await database.getAllTextsOfUser(1);
      expect(texts, [tValidTextModel1, tValidTextModel2]);
    });
  });

  group("update", () {
    setUp(() async {
      await database.insertText(tValidTextCompanion);
    });

    test("should return true when updating a valid text", () async {
      final tValidUpdateTextModel = TextModel(
        title: title,
        body: updateBody,
        studentId: tValidStudentPk,
        localId: tValidTextPk1,
        tutorId: 1,
        creationDate: DateTime(2020),

      );

      final done = await database.updateText(tValidUpdateTextModel);

      expect(done, true);
    });

    test("should return false when updating an invalid text", () async {
      final tInvalidUpdateTextModel = TextModel(
        localId: tInvalidTextPk,
        title: title,
        body: updateBody,
        studentId: tValidStudentPk,
        tutorId: 2,
        creationDate: DateTime(2020),

      );

      final done = await database.updateText(tInvalidUpdateTextModel);

      expect(done, false);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

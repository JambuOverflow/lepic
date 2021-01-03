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
  final tValidClassroomPk = 1;
  final tInvalidClassroomPk = 2;
  final title = "A";
  final updateBody = "C";
  final body = "B";

  final tValidTextCompanion = TextModelsCompanion(
      title: Value(title),
      body: Value(body),
      classId: Value(tValidClassroomPk));

  final tInvalidTextCompanion = TextModelsCompanion(
      title: Value(title),
      body: Value(body),
      classId: Value(tInvalidClassroomPk));

  final tValidTextModel1 = TextModel(
      title: title,
      body: body,
      classId: tValidClassroomPk,
      localId: tValidTextPk1);

  final tValidTextModel2 = TextModel(
      title: title,
      body: body,
      classId: tValidClassroomPk,
      localId: tValidTextPk2);

  final tValidUpdateTextModel = TextModel(
      title: title,
      body: updateBody,
      classId: tValidClassroomPk,
      localId: tValidTextPk1);

  final tInvalidUpdateTextModel = TextModel(
      localId: tInvalidTextPk,
      title: title,
      body: updateBody,
      classId: tValidClassroomPk);

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

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    await database.into(database.userModels).insert(tUserCompanion);
    await database.into(database.classroomModels).insert(tClassroomCompanion);
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

  group("getTexts", () {
    test("should return an empty list of texts", () async {
      final texts = await database.getTextsOfClassroom(tValidClassroomPk);
      expect(texts, []);
    });

    test("should return a list with one text", () async {
      await database.insertText(tValidTextCompanion);

      final texts = await database.getTextsOfClassroom(tValidClassroomPk);
      expect(texts, [tValidTextModel1]);
    });

    test("should return a list with two texts", () async {
      await database.insertText(tValidTextCompanion);
      await database.insertText(tValidTextCompanion);

      final texts = await database.getTextsOfClassroom(tValidClassroomPk);
      expect(texts, [tValidTextModel1, tValidTextModel2]);
    });
  });

  group("getTexts", () {
    setUp(() async {
      await database.insertText(tValidTextCompanion);
    });

    test("should return true when updating a valid text", () async {
      final done = await database.updateText(tValidUpdateTextModel);
      expect(done, true);
    });

    test("should return false when updating an invalid text", () async {
      final done = await database.updateText(tInvalidUpdateTextModel);
      expect(done, false);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

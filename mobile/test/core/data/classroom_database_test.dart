import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidClassroomPk1 = 1;
  final tValidSchoolPk1 = 1;
  final tValidClassroomPk2 = 2;
  final tInvalidClassroomPk = 2;
  final tValidUserPk = 1;
  final tInvalidUserPk = 2;
  final grade = 1;
  final name = "A";
  final updateName = "B";
  final zipCode = 1;
  final Modality modality = Modality.public;
  final String state = "PA";
  final String city = "Belém";
  final String neighborhood = "Nazaré";

  final tValidClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    title: Value(name),
    tutorId: Value(tValidUserPk),
    deleted: Value(false),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
    schoolId: Value(tValidSchoolPk1),
  );

  final tDeletedClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    title: Value(name),
    tutorId: Value(tValidUserPk),
    deleted: Value(true),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
    schoolId: Value(tValidSchoolPk1),
  );

  final tInvalidClassCompanion = ClassroomModelsCompanion(
    grade: Value(grade),
    title: Value(name),
    tutorId: Value(tInvalidUserPk),
    deleted: Value(false),
    lastUpdated: Value(DateTime(2020)),
    clientLastUpdated: Value(DateTime(2020)),
    schoolId: Value(tValidSchoolPk1),
  );

  final tValidClassModel1 = ClassroomModel(
    grade: grade,
    title: name,
    tutorId: tValidUserPk,
    localId: tValidClassroomPk1,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
    schoolId: tValidSchoolPk1,
  );

  final tValidClassModel2 = ClassroomModel(
    grade: grade,
    title: name,
    tutorId: tValidUserPk,
    localId: tValidClassroomPk2,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
    schoolId: tValidSchoolPk1,
  );

  final tValidUpdateClassModel = ClassroomModel(
      grade: grade,
      title: updateName,
      tutorId: tValidUserPk,
      localId: tValidClassroomPk1,
      deleted: false,
      lastUpdated: DateTime(2020),
      clientLastUpdated: DateTime(2020),
      schoolId: tValidSchoolPk1);

  final tInvalidUpdateClassModel = ClassroomModel(
    localId: tInvalidClassroomPk,
    grade: grade,
    title: updateName,
    tutorId: tValidUserPk,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
    schoolId: tValidSchoolPk1,
  );

  final tClassModel2018 = ClassroomModel(
    grade: grade,
    title: updateName,
    tutorId: tValidUserPk,
    deleted: false,
    lastUpdated: DateTime(2018),
    clientLastUpdated: DateTime(2018),
    schoolId: tValidSchoolPk1,
  );

  final tClassModel2019 = ClassroomModel(
    grade: grade,
    title: updateName,
    tutorId: tValidUserPk,
    deleted: false,
    lastUpdated: DateTime(2019),
    clientLastUpdated: DateTime(2019),
    schoolId: tValidSchoolPk1,
  );

  final tClassModel2020 = ClassroomModel(
    grade: grade,
    title: updateName,
    tutorId: tValidUserPk,
    deleted: false,
    lastUpdated: DateTime(2020),
    clientLastUpdated: DateTime(2020),
    schoolId: tValidSchoolPk1,
  );

  final tUserCompanion = UserModelsCompanion(
    firstName: Value("cana"),
    lastName: Value("varro"),
    email: Value("dede@.com"),
    username: Value("dede@.com"),
    role: Value(Role.teacher),
    password: Value("1234"),
  );

  final tValidSchoolCompanion = SchoolModelsCompanion(
    name: Value(name),
    zipCode: Value(zipCode),
    modality: Value(modality),
    state: Value(state),
    city: Value(city),
    neighborhood: Value(neighborhood),
    userId: Value(tValidUserPk),
  );

  Database database;
  VmDatabase vmDatabase;

  Future connectDatabase() async {
    vmDatabase = VmDatabase.memory(setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    database = Database(vmDatabase);
    await database.into(database.userModels).insert(tUserCompanion);
    await database.into(database.schoolModels).insert(tValidSchoolCompanion);
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

  group("getClassroomsSinceLastSync", () {
    test("should return an empty list of classrooms", () async {
      final lastSync = DateTime(2020);
      final classrooms = await database.getClassroomsSinceLastSync(
        lastSync,
      );
      expect(classrooms, []);
    });

    test("should return a list with one classroom", () async {
      final pk =
          await database.insertClassroom(tClassModel2020.toCompanion(true));
      final lastSync = DateTime(2020);

      final classrooms = await database.getClassroomsSinceLastSync(lastSync);
      expect(classrooms, [tClassModel2020.copyWith(localId: pk)]);
    });

    test("should return a list with one valid classroom", () async {
      await database.insertClassroom(tClassModel2018.toCompanion(true));
      final pk2 =
          await database.insertClassroom(tClassModel2019.toCompanion(true));
      final lastSync = DateTime(2019);

      final classrooms = await database.getClassroomsSinceLastSync(lastSync);
      expect(classrooms, [tClassModel2019.copyWith(localId: pk2)]);
    });

    test("should return a list with two classrooms", () async {
      final pk1 =
          await database.insertClassroom(tClassModel2020.toCompanion(true));
      final pk2 =
          await database.insertClassroom(tClassModel2019.toCompanion(true));
      final lastTime = DateTime(2017);

      final classrooms = await database.getClassroomsSinceLastSync(lastTime);
      expect(classrooms, [
        tClassModel2020.copyWith(localId: pk1),
        tClassModel2019.copyWith(localId: pk2),
      ]);
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

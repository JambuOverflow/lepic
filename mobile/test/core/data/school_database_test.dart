import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidSchoolPk1 = 1;
  final tValidSchoolPk2 = 2;
  final tInvalidSchoolPk = 2;

  final tValidUserPk = 1;
  final tInvalidUserPk = 2;

  final zipCode = 1;
  final Modality modality = Modality.public;
  final String state = "PA";
  final String city = "Belém";
  final String neighborhood = "Nazaré";

  final name = "A";
  final updateName = "B";

  final tValidSchoolCompanion = SchoolModelsCompanion(
    name: Value(name),
    zipCode: Value(zipCode),
    modality: Value(modality),
    state: Value(state),
    city: Value(city),
    neighborhood: Value(neighborhood),
    userId: Value(tValidUserPk),
  );

  final tInvalidSchoolCompanion = SchoolModelsCompanion(
    name: Value(name),
    zipCode: Value(zipCode),
    modality: Value(modality),
    state: Value(state),
    city: Value(city),
    neighborhood: Value(neighborhood),
    userId: Value(tInvalidUserPk),
  );

  final tValidSchoolModel1 = SchoolModel(
    localId: tValidSchoolPk1,
    userId: tValidUserPk,
    name: name,
    zipCode: zipCode,
    modality: modality,
    state: state,
    city: city,
    neighborhood: neighborhood,
  );

  final tValidSchoolModel2 = SchoolModel(
    localId: tValidSchoolPk2,
    userId: tValidUserPk,
    name: name,
    zipCode: zipCode,
    modality: modality,
    state: state,
    city: city,
    neighborhood: neighborhood,
  );

  final tValidUpdateSchoolModel = SchoolModel(
    localId: tValidSchoolPk1,
    userId: tValidUserPk,
    name: updateName,
    zipCode: zipCode,
    modality: modality,
    state: state,
    city: city,
    neighborhood: neighborhood,
  );

  final tInvalidUpdateSchoolModel = SchoolModel(
    localId: tValidSchoolPk2,
    userId: tInvalidUserPk,
    name: name,
    zipCode: zipCode,
    modality: modality,
    state: state,
    city: city,
    neighborhood: neighborhood,
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
    test("should return the pk of a valid school when inserted", () async {
      final pk = await database.insertSchool(tValidSchoolCompanion);

      expect(pk, tValidSchoolPk1);
    });

    test("should return a SQLite error", () async {
      expect(() => database.insertSchool(tInvalidSchoolCompanion),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteSchool", () {
    setUp(() async {
      await database.insertSchool(tValidSchoolCompanion);
    });

    test(
        "should return 1 indicating that a row was deleted when the input is a valid pk",
        () async {
      final deleted = await database.deleteSchool(tValidSchoolPk1);
      expect(deleted, 1);
    });

    test(
        "should return 0 indicating that no rows were deleted when the input is an invalid pk",
        () async {
      final deleted = await database.deleteSchool(tInvalidSchoolPk);
      expect(deleted, 0);
    });
  });

  group("getSchools", () {
    test("should return an empty list of schools", () async {
      final schools = await database.getSchools(tValidUserPk);
      expect(schools, []);
    });

    test("should return a list with one school", () async {
      await database.insertSchool(tValidSchoolCompanion);

      final schools = await database.getSchools(tValidUserPk);
      expect(schools, [tValidSchoolModel1]);
    });

    test("should return a list with two schools", () async {
      await database.insertSchool(tValidSchoolCompanion);
      await database.insertSchool(tValidSchoolCompanion);

      final schools = await database.getSchools(tValidUserPk);
      expect(schools, [tValidSchoolModel1, tValidSchoolModel2]);
    });
  });

  group("getSchools", () {
    setUp(() async {
      await database.insertSchool(tValidSchoolCompanion);
    });

    test("should return true when updating a valid school", () async {
      final done = await database.updateSchool(tValidUpdateSchoolModel);
      expect(done, true);
    });

    test("should return false when updating an invalid school", () async {
      final done = await database.updateSchool(tInvalidUpdateSchoolModel);
      expect(done, false);
    });
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:matcher/matcher.dart';

void main() {
  final tValidAudioPk1 = 1;
  final tValidAudioPk2 = 2;
  final tInvalidAudioPk = 3;

  final tValidTextPk = 1;
  final tInvalidTextPk = 2;

  final tValidStudentPk = 1;
  final tInvalidStudentPk = 2;

  final firstName = "A";
  final lastName = "B";
  final updateFirstName = "C";

  Uint8List audioData = Uint8List.fromList([]);

  final tValidAudioModelInput = AudioModel(
    textId: tValidTextPk,
    studentId: tValidStudentPk,
    title: "",
    audioData: audioData,
  );

  final tClassroomCompanion = ClassroomModelsCompanion(
    name: Value("A"),
    grade: Value(1),
    tutorId: Value(1),
    lastUpdated: Value(DateTime(0)),
    clientLastUpdated: Value(DateTime(0)),
    deleted: Value(false),
  );

  final tValidAudioModelOutput = tValidAudioModelInput.copyWith(localId: 1);

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

  group("insertAudio", () {
    test("should return the pk of a valid audio when inserted", () async {
      final pk = await database.insertAudio(tValidAudioModelInput);
      expect(pk, tValidAudioPk1);
    });

    test("should return a SQLite error if student pk is invalid", () async {
      expect(
          () => database
              .insertAudio(tValidAudioModelInput.copyWith(studentId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });

    test("should return a SQLite error if text pk is invalid", () async {
      expect(
          () => database.insertAudio(tValidAudioModelInput.copyWith(textId: 2)),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("deleteAudio", () {
    setUp(() async {
      await database.insertAudio(tValidAudioModelInput);
    });

    test("should run without throwing an exception", () async {
      await database.deleteAudio(tValidAudioPk1);

      final result =
          await database.getAllAudiosOfStudent(tValidAudioModelInput.studentId);

      expect(result, []);
    });

    test("""should throw an exception when the database does not contain
         audios with the textPk passed""", () async {
      expect(() => database.deleteAudio(2),
          throwsA(TypeMatcher<SqliteException>()));
    });
  });

  group("getAllAudiosOfStudent", () {
    test("should return an empty list of audios", () async {
      final audios = await database.getAllAudiosOfStudent(1);
      expect(audios, []);
    });

    test("should return a list with one audio", () async {
      await database.insertAudio(tValidAudioModelInput);
      await database.insertStudent(tStudentCompanion);
      await database.insertAudio(tValidAudioModelInput.copyWith(studentId: 2));

      final audios = await database.getAllAudiosOfStudent(1);
      equals(audios.length == 0);
      expect(audios[0].localId, 1);
      expect(audios[0].textId, tValidAudioModelInput.textId);
      expect(audios[0].studentId, tValidAudioModelInput.studentId);
      expect(audios[0].title, tValidAudioModelInput.title);
      equals(listEquals(audios[0].audioData, tValidAudioModelInput.audioData));
    });
  });

  group("getAudio", () {
    test("should return one audio", () async {
      await database.insertAudio(tValidAudioModelInput);
      final audio = await database.getAudio(studentPk: 1, textPk: 1);
      expect(audio.localId, 1);
      expect(audio.textId, tValidAudioModelInput.textId);
      expect(audio.studentId, tValidAudioModelInput.studentId);
      expect(audio.title, tValidAudioModelInput.title);
      equals(listEquals(audio.audioData, tValidAudioModelInput.audioData));
    });

    test("should throw an sqliteException", () async {

      expect(
          () async => await database
              .getAudio(studentPk: 1, textPk: 1),
          throwsA(TypeMatcher<SqliteException>()));
    });
    
  });

  group("updateAudio", () {
    test("should update correclty", () async {
      await database.insertAudio(tValidAudioModelInput);
      
      await database.updateAudio(tValidAudioModelOutput.copyWith(title:"Arg"));
      final AudioModel audio = await database.getAudio(studentPk:1, textPk:1);
      expect(audio.localId, 1);
      expect(audio.textId, tValidAudioModelInput.textId);
      expect(audio.studentId, tValidAudioModelInput.studentId);
      expect(audio.title, "Arg");
      equals(listEquals(audio.audioData, tValidAudioModelInput.audioData));
    });

    test("should throw an exception", () async {
      
      expect(
          () async => await database
              .updateAudio(tValidAudioModelOutput),
          throwsA(TypeMatcher<SqliteException>()));
    });
    
  });
}

void closeDatabase(Database database) async {
  await database.close();
}

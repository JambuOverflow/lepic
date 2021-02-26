import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/audio_management/data/models/audio_model.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
import 'package:mobile/features/text_correction/data/models/correction_model.dart';
import 'package:mobile/features/text_correction/data/models/mistake_model.dart';
import 'package:mobile/features/text_management/data/models/text_model.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import '../../features/user_management/data/models/user_model.dart';
import 'package:clock/clock.dart';

import '../../main.dart';

part 'database.g.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final db = VmDatabase(file, setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    if (IS_IN_DEVELOPMENT) await file.delete();
    return db;
  });
}

@UseMoor(tables: [
  UserModels,
  ClassroomModels,
  StudentModels,
  TextModels,
  MistakeModels,
  AudioModels,
  CorrectionModels,
])
class Database extends _$Database {
  final clock = Clock();
  Database(QueryExecutor e) : super(e);
  Database.customExecutor(QueryExecutor executor) : super(executor);

  /// Returns the primary key (pk) of the added entry
  Future<int> insertClassroom(ClassroomModelsCompanion modelCompanion) async {
    return into(classroomModels).insert(modelCompanion);
  }

  /// Returns a [Classroom]
  Future<ClassroomModel> getClassroom(int classroomId) async {
    final ClassroomModel result = await (select(classroomModels)
          ..where((t) => t.localId.equals(classroomId)))
        .getSingle();
    if (result == null) {
      throw SqliteException(787, "The table doesn't have this entry");
    }
    return result;
  }

  /// Returns a list of [ClassroomModel] that weren't deleted
  ///
  /// Returns an empty list when the table is empty
  Future<List<ClassroomModel>> getClassrooms(int tutorId) async {
    return (select(classroomModels)
          ..where((t) => t.tutorId.equals(tutorId) & t.deleted.equals(false)))
        .get();
  }

  /// Returns true if the classroom exists, and false otherwise
  Future<bool> classroomExists(int id) async {
    final classroomModel = await (select(classroomModels)
          ..where((t) => t.localId.equals(id)))
        .getSingle();
    return (classroomModel != null);
  }

  /// Throws [SqliteException] if the table doesn't contain the entry
  Future<void> updateClassroom(ClassroomModel entry) async {
    var done = await update(classroomModels).replace(entry);
    if (!done) {
      throw SqliteException(787, "The table does not contain this entry");
    }
  }

  /// Returns the primary key (pk) of the added entry
  Future<int> insertStudent(StudentModelsCompanion modelCompanion) async {
    return into(studentModels).insert(modelCompanion);
  }

  /// Returns the number of deleted rows
  Future<int> deleteStudent(int id) async {
    return (delete(studentModels)..where((t) => t.localId.equals(id))).go();
  }

  Future<StudentModel> getStudent(int params) async {
    final StudentModel result = await (select(studentModels)
          ..where((t) => t.localId.equals(params)))
        .getSingle();
    if (result == null) {
      throw SqliteException(787, "The table doesn't have this entry");
    }
    return result;
  }

  /// Returns a List of [StudentModel]
  ///
  /// Returns an empty list if the table is empty
  Future<List<StudentModel>> getStudents(int classroomId) async {
    return (select(studentModels)
          ..where((t) => t.classroomId.equals(classroomId)))
        .get();
  }

  /// Returns true if the student was updated, false otherwise
  Future<bool> updateStudent(StudentModel entry) async {
    return update(studentModels).replace(entry);
  }

  /// Returns the primary key (pk) of the added entry
  Future<int> insertText(TextModelsCompanion textCompanion) async {
    return into(textModels).insert(textCompanion);
  }

  /// Throws [SqliteException] if the entry is not found
  Future<void> deleteText(int id) async {
    var done =
        await (delete(textModels)..where((t) => t.localId.equals(id))).go();
    if (done != 1) {
      throw SqliteException(787, "The table doesn't have this entry");
    }
  }

  /// Returns a list of [TextModel] from a student
  Future<List<TextModel>> getStudentTexts(int studentId) async {
    return (select(textModels)..where((t) => t.studentId.equals(studentId)))
        .get();
  }

  /// Returns a [TextModel]
  Future<TextModel> getText(int textId) async {
    final TextModel result = await (select(textModels)
          ..where((t) => t.localId.equals(textId)))
        .getSingle();
    if (result == null) {
      throw SqliteException(787, "The table doesn't have this entry");
    }
    return result;
  }

  /// Returns a list of [TextModel]
  Future<List<TextModel>> getAllTextsOfUser(int tutorId) async {
    return (select(textModels)..where((t) => t.tutorId.equals(tutorId))).get();
  }

  /// Returns true if the text was updated, false otherwise
  Future<bool> updateText(TextModel entry) async {
    return update(textModels).replace(entry);
  }

  /// Returns the primary key (pk) of the added entry
  /// Throws SqliteException if can't add entry
  Future<int> insertMistake(MistakeModel entry) async {
    return into(mistakeModels).insert(entry);
  }

  /// Deletes all mistakes from  a correction
  /// Throws SqliteException if no entry is found
  Future<void> deleteCorrectionMistakes(int correctionPk) async {
    var done = await (delete(mistakeModels)
          ..where((t) => t.correctionId.equals(correctionPk)))
        .go();
    if (done != 1) {
      throw SqliteException(
          787, "The table doesn't have mistakes with this text and student");
    }
  }

  /// Returns all mistakes from  a correction
  /// Returns an empty list if no entry is found
  Future<List<MistakeModel>> getMistakesOfCorrection(int correctionPk) async {
    return await (select(mistakeModels)
          ..where((t) => t.correctionId.equals(correctionPk)))
        .get();
  }

  /// Returns all mistakes in database
  /// Returns an empty list if no entry is found
  Future<List<MistakeModel>> getAllMistakes() async {
    return await (select(mistakeModels)).get();
  }

  Future<int> insertCorrection(CorrectionModel correctionModel) async {
    return await into(correctionModels).insert(correctionModel);
  }

  Future<void> deleteCorrection(int correctionPk) async {
    var done =
        await (delete(correctionModels)..where((t) => t.localId.equals(correctionPk))).go();
    if (done != 1) {
      throw SqliteException(787, "The table doesn't have this entry");
    }
  }

  Future<CorrectionModel> getCorrection({int studentId, int textId}) async {
    var result = await (select(correctionModels)
          ..where(
              (t) => t.textId.equals(textId) & t.studentId.equals(studentId)))
        .getSingle();
    if (result == null) {
      throw EmptyDataException();
    }
    return result;
  }

  /// Returns the pk of the inserted model
  /// Throws a sqliteException if it can't insert the model
  Future<int> insertAudio(AudioModel model) async {
    return await into(audioModels).insert(model);
  }

  /// Deletes a model
  /// Throws a sqliteException if the model is not in the database
  Future<void> deleteAudio(int pk) async {
    var done =
        await (delete(audioModels)..where((t) => t.localId.equals(pk))).go();
    if (done != 1) {
      throw SqliteException(
          787, "The table doesn't have mistakes with this text and student");
    }
  }

  /// Gets all audios of a student
  /// Throws a sqliteException if the student is not present in the database
  Future<List<AudioModel>> getAllAudiosOfStudent(int studentPk) async {
    return await (select(audioModels)
          ..where((t) => t.studentId.equals(studentPk)))
        .get();
  }

  /// Gets one audio
  /// Throws a sqliteException if audio is not present in the database
  Future<AudioModel> getAudio({int studentPk, int textPk}) async {
    var result = await (select(audioModels)
          ..where(
              (t) => t.textId.equals(textPk) & t.studentId.equals(studentPk)))
        .getSingle();
    if (result == null) {
      throw EmptyDataException();
    }
    return result;
  }

  /// Updates audio
  /// Throws a sqliteException if audio is not present in the database
  Future<void> updateAudio(AudioModel model) async {
    final bool done = await update(audioModels).replace(model);
    if (!done) {
      throw SqliteException(787, "Model is not in the database");
    }
  }

  

  @override
  int get schemaVersion => 6;


}

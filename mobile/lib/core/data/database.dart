import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
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

@UseMoor(tables: [UserModels, ClassroomModels, StudentModels, TextModels])
class Database extends _$Database {
  final clock = Clock();
  Database(QueryExecutor e) : super(e);
  Database.customExecutor(QueryExecutor executor) : super(executor);

  /// Returns the primary key (pk) of the added entry
  Future<int> insertClassroom(ClassroomModelsCompanion modelCompanion) async {
    return into(classroomModels).insert(modelCompanion);
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

  /// Returns a list of [TextModel] from a classroom
  Future<List<TextModel>> getTextsOfClassroom(int classroomId) async {
    return (select(textModels)..where((t) => t.classId.equals(classroomId)))
        .get();
  }

  /// Returns a list of [TextModel]
  Future<List<TextModel>> getTexts(int tutorId) async {
    return (select(textModels)..where((t) => t.tutorId.equals(tutorId)))
        .get();
  }

  /// Returns true if the text was updated, false otherwise
  Future<bool> updateText(TextModel entry) async {
    return update(textModels).replace(entry);
  }

  @override
  int get schemaVersion => 4;
}

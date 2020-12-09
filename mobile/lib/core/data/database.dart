import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/user_management/data/models/user_model.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final db = VmDatabase(file, setup: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    });
    return db;
  });
}

@UseMoor(tables: [UserModels, ClassroomModels])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  Future<int> insertClassroom(ClassroomModelsCompanion modelCompanion) async {
    /// returns the pk of the added entry
    return into(classroomModels).insert(modelCompanion);
  }

  Future<int> deleteClassroom(int id) async {
    ///Returns the number of deleted rows
    return (delete(classroomModels)..where((t) => t.localId.equals(id))).go();
  }

  Future<List<ClassroomModel>> getClassrooms(int tutorId) async {
    return (select(classroomModels)..where((t) => t.tutorId.equals(tutorId)))
        .get();
  }

  Future<bool> updateClassroom(ClassroomModel entry) async {
    return update(classroomModels).replace(entry);
  }

  @override
  int get schemaVersion => 2;
}

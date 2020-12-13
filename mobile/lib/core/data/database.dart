import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
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

@UseMoor(tables: [UserModels, ClassroomModels, StudentModels])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);
  Database.customExecutor(QueryExecutor executor) : super(executor);

  Future<UserModel> get activeUser => select(userModels).getSingle();
  Future<UserModel> userById(int id) {
    return (select(userModels)..where((t) => t.localId.equals(id))).getSingle();
  }

  Future<bool> updateUser(UserModel model) async {
    return update(userModels).replace(model);
  }

  Future<int> insertUser(UserModel model) async {
    return into(userModels).insert(model);
  }

  /// returns the pk of the added entry
  Future<int> insertClassroom(ClassroomModelsCompanion modelCompanion) async {
    return into(classroomModels).insert(modelCompanion);
  }

  ///Returns the number of deleted rows
  Future<int> deleteClassroom(int id) async {
    return (delete(classroomModels)..where((t) => t.localId.equals(id))).go();
  }

  ///Returns a list of classroomModels, and an empty list with the table is empty
  Future<List<ClassroomModel>> getClassrooms(int tutorId) async {
    return (select(classroomModels)..where((t) => t.tutorId.equals(tutorId)))
        .get();
  }

  ///Returns true if the class was updated, false otherwise
  Future<bool> updateClassroom(ClassroomModel entry) async {
    return update(classroomModels).replace(entry);
  }

  @override
  int get schemaVersion => 2;
}

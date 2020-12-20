import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

abstract class ClassroomLocalDataSource {
  /// Gets the cached list of [Classroom].
  ///
  /// Returns an empty list if no [Classroom] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<ClassroomModel>> getClassroomsFromCache(UserModel userModel);

  /// Deletes the [Classroom] passed.
  ///
  /// Throws [CacheException] if the [Classroom] is not cached.
  Future<void> deleteClassroomFromCache(ClassroomModel classroomModel);

  /// Caches the new [Classroom] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<ClassroomModel> cacheNewClassroom(ClassroomModel classroomModel);

  /// Updated in cache the [Classroom] passed.
  ///
  /// Throws [CacheException] if [Clasroom] is not cached.
  Future<ClassroomModel> updateCachedClassroom(ClassroomModel classroomModel);
}

class ClassroomLocalDataSourceImpl implements ClassroomLocalDataSource {
  final Database database;

  ClassroomLocalDataSourceImpl({@required this.database});

  @override
  Future<ClassroomModel> cacheNewClassroom(
      ClassroomModel classroomModel) async {
    try {
      bool nullToAbsent = true;
      final classCompanion = classroomModel.toCompanion(nullToAbsent);
      final classPk = await this.database.insertClassroom(classCompanion);
      return ClassroomModel(
          grade: classroomModel.grade,
          tutorId: classroomModel.tutorId,
          name: classroomModel.name,
          localId: classPk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteClassroomFromCache(ClassroomModel classroomModel) async {
    var pk = classroomModel.localId;
    try {
      var done = await this.database.deleteClassroom(pk);
      if (done != 1) {
        throw SqliteException(787, "The table doesn't have this entry");
      }
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<ClassroomModel>> getClassroomsFromCache(
      UserModel userModel) async {
    final tutorId = userModel.localId;
    try {
      return await this.database.getClassrooms(tutorId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<ClassroomModel> updateCachedClassroom(
      ClassroomModel classroomModel) async {
    bool updated = await this.database.updateClassroom(classroomModel);
    if (updated) {
      return classroomModel;
    } else {
      throw CacheException();
    }
  }
}

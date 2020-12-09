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
      final classCompanion = classroomModelToCompanion(classroomModel);
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
    print("netrou");
    try {
      var done = await this.database.deleteClassroom(pk);
      print(done);
      if (done != 1) {
        throw SqliteException(787, "The table don't have this entry");
      }
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<ClassroomModel>> getClassroomsFromCache(UserModel userModel) {
    // TODO: implement getClassrooms
    throw UnimplementedError();
  }

  @override
  Future<ClassroomModel> updateCachedClassroom(ClassroomModel classroomModel) {
    // TODO: implement updateCachedClassroom
    throw UnimplementedError();
  }
}

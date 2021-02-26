import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

abstract class ClassroomLocalDataSource {
  /// Gets the cached list of [Classroom].
  ///
  /// Returns an empty list if no [Classroom] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<ClassroomModel>> getClassroomsFromCache();

  /// Deletes the [Classroom] passed.
  ///
  /// Throws [CacheException] if the [Classroom] is not cached.
  Future<void> deleteClassroomFromCache(ClassroomModel classroomModel);

  /// Caches the new [Classroom] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<ClassroomModel> cacheNewClassroom(ClassroomModel classroomModel);

  /// Updates in cache the [Classroom] passed.
  ///
  /// Throws [CacheException] if [Clasroom] is not cached.
  Future<ClassroomModel> updateCachedClassroom(ClassroomModel classroomModel);

  /// Updates in cache the [Classroom] passed if the [Classroom] already exists.
  /// Creates the [Classroom] if it does not yet exists.
  /// Throws [CacheException] if something wrong happens.
  Future<ClassroomModel> cacheClassroom(ClassroomModel classroomModel);

  Future<ClassroomModel> getClassroomFromCacheWithId(int i);
}

class ClassroomLocalDataSourceImpl implements ClassroomLocalDataSource {
  final Database database;
  final UserLocalDataSource userLocalDataSource;

  ClassroomLocalDataSourceImpl({
    @required this.database,
    @required this.userLocalDataSource,
  });

  @override
  Future<ClassroomModel> cacheNewClassroom(
      ClassroomModel classroomModel) async {
    try {
      bool nullToAbsent = true;
      final classCompanion = classroomModel.toCompanion(nullToAbsent);
      final classPk = await this.database.insertClassroom(classCompanion);

      return classroomModel.copyWith(localId: classPk, deleted: false);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteClassroomFromCache(ClassroomModel classroomModel) async {
    ClassroomModel deletedClassroomModel =
        classroomModel.copyWith(deleted: true);
    try {
      await this.database.updateClassroom(deletedClassroomModel);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<ClassroomModel>> getClassroomsFromCache() async {
    try {
      final tutorId = await userLocalDataSource.getUserId();
      return await this.database.getClassrooms(tutorId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<ClassroomModel> cacheClassroom(ClassroomModel classroomModel) async {
    bool classroomExists;
    if (classroomModel.localId == null) {
      classroomExists = false;
    } else {
      classroomExists =
          await this.database.classroomExists(classroomModel.localId);
    }
    if (classroomExists) {
      return updateCachedClassroom(classroomModel);
    } else {
      return cacheNewClassroom(classroomModel);
    }
  }

  @override
  Future<ClassroomModel> updateCachedClassroom(
      ClassroomModel classroomModel) async {
    try {
      await this.database.updateClassroom(classroomModel);
      return classroomModel;
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<ClassroomModel> getClassroomFromCacheWithId(int i) async {
    try {
      return await this.database.getClassroom(i);
    } on SqliteException {
      throw CacheException();
    }
  }
}

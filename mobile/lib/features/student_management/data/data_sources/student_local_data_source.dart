import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

abstract class StudentLocalDataSource {
  /// Gets the cached list of [Student].
  ///
  /// Returns an empty list if no [Student] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<StudentModel>> getStudentsFromCache(ClassroomModel clasroomModel);

  /// Deletes the [Student] passed.
  ///
  /// Throws [CacheException] if the [Student] is not cached.
  Future<void> deleteStudentFromCache(StudentModel studentModel);

  /// Caches the new [Student] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<StudentModel> cacheNewStudent(StudentModel studentModel);

  /// Updated in cache the [Student] passed.
  ///
  /// Throws [CacheException] if [Student] is not cached.
  Future<StudentModel> updateCachedStudent(StudentModel studentModel);
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final Database database;

  StudentLocalDataSourceImpl({@required this.database});

  @override
  Future<StudentModel> cacheNewStudent(StudentModel studentModel) async {
    try {
      bool nullToAbsent = true;
      final studentCompanion = studentModel.toCompanion(nullToAbsent);
      final studentPk = await this.database.insertStudent(studentCompanion);
      return StudentModel(
          localId: studentPk,
          firstName: studentModel.firstName,
          lastName: studentModel.lastName,
          classroomId: studentModel.classroomId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteStudentFromCache(StudentModel studentModel) async {
    var pk = studentModel.localId;
    try {
      var done = await this.database.deleteStudent(pk);
      if (done != 1) {
        throw SqliteException(787, "The table doesn't have this entry");
      }
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<StudentModel>> getStudentsFromCache(
      ClassroomModel classroomModel) async {
    final classroomId = classroomModel.localId;
    try {
      return await this.database.getStudents(classroomId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<StudentModel> updateCachedStudent(StudentModel studentModel) async {
    bool updated = await this.database.updateStudent(studentModel);
    if (updated) {
      return studentModel;
    } else {
      throw CacheException();
    }
  }
}

import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/class_management/data/models/classroom_model.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/student_management/data/models/student_model.dart';
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

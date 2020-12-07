import 'package:mobile/features/class_management/domain/entities/classroom.dart';

abstract class ClassroomLocalDataSource {
  /// Gets the cached list of [Classroom].
  ///
  /// Throws [CacheException] if there's no cached [Classroom].
  Future<List<Classroom>> getClassrooms();

  /// Deletes the [Classroom] passed.
  ///
  /// Throws [CacheException] if the [Classroom] is not cached.
  Future<void> deleteClassroomFromCache(Classroom classroom);

  Future<Classroom> cacheClassroom(Classroom classroom);
}

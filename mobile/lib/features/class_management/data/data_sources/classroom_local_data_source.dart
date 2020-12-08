import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/domain/entities/user.dart';

abstract class ClassroomLocalDataSource {
  /// Gets the cached list of [Classroom].
  ///
  /// Throws [CacheException] if there's no cached [Classroom].
  Future<List<Classroom>> getClassrooms(User user);

  /// Deletes the [Classroom] passed.
  ///
  /// Throws [CacheException] if the [Classroom] is not cached.
  Future<void> deleteClassroomFromCache(Classroom classroom);

  /// Caches the [Classroom] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<Classroom> cacheClassroom(Classroom classroom);
}

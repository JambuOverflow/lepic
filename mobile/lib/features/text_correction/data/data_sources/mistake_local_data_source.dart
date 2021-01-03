import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';

abstract class MistakeLocalDataSource {
  /// Gets the cached list of [Mistake] of a specific correctiion (student and text).
  ///
  /// Returns an empty list if no [Mistake] is cache.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<MistakeModel>> getMistakesFromCacheOfCorrection(
    StudentModel studentModel,
    TextModel textModel,
  );

  /// Deletes all the [Mistake] from a specific collection.
  ///
  /// Throws [CacheException] if the [Collection] is not cached.
  Future<void> deleteAllMistakesFromCacheOfCorrection(MistakeModel mistakeModel);

  /// Caches the new [Mistake] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<MistakeModel> cacheNewMistake(MistakeModel mistakeModel);
}

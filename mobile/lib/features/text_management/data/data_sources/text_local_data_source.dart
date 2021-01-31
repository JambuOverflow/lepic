import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

abstract class TextLocalDataSource {
  /// Gets the cached list of [Text] from a specific classroom.
  ///
  /// Returns an empty list if no [Text] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<TextModel>> getStudentTextsFromCache(StudentModel studentModel);

  /// Gets the cached list of [Text].
  ///
  /// Returns an empty list if no [Text] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<TextModel>> getAllUserTextsFromCache();

  /// Deletes the [Text] passed.
  ///
  /// Throws [CacheException] if the [Text] is not cached.
  Future<void> deleteTextFromCache(TextModel textModel);

  /// Caches the new [Text] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<TextModel> cacheNewText(TextModel textModel);

  /// Updated in cache the [Text] passed.
  ///
  /// Throws [CacheException] if [Clasroom] is not cached.
  Future<TextModel> updateCachedText(TextModel textModel);
}

class TextLocalDataSourceImpl implements TextLocalDataSource {
  final Database database;
  final UserLocalDataSource userLocalDataSource;

  TextLocalDataSourceImpl({
    @required this.database,
    @required this.userLocalDataSource,
  });

  @override
  Future<TextModel> cacheNewText(TextModel textModel) async {
    try {
      bool nullToAbsent = true;
      final textCompanion = textModel.toCompanion(nullToAbsent);
      final textPk = await this.database.insertText(textCompanion);
      return textModel.copyWith(localId: textPk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteTextFromCache(TextModel textModel) async {
    var pk = textModel.localId;
    try {
      await this.database.deleteText(pk);
      return null;
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<TextModel>> getStudentTextsFromCache(
      StudentModel studentModel) async {
    final classId = studentModel.localId;
    try {
      return await this.database.getStudentTexts(classId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<TextModel> updateCachedText(TextModel textModel) async {
    bool updated = await this.database.updateText(textModel);
    if (updated) {
      return textModel;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<TextModel>> getAllUserTextsFromCache() async {
    try {
      final tutorId = await userLocalDataSource.getUserId();
      return await this.database.getAllTextsOfUser(tutorId);
    } on SqliteException {
      throw CacheException();
    }
  }
}

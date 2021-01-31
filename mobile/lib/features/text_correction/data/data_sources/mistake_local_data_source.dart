import 'package:flutter/cupertino.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:moor/ffi.dart';

abstract class MistakeLocalDataSource {
  /// Gets the cached list of [Mistake] of a specific correctiion (student and text).
  ///
  /// Returns an empty list if no [Mistake] is cache.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<MistakeModel>> getCorrectionMistakesFromCache({
    StudentModel studentModel,
    TextModel textModel,
  });

  /// Gets the cached list of [Mistake] of a specific correctiion (student and text).
  ///
  /// Returns an empty list if no [Mistake] is cache.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<MistakeModel>> getCorrectionMistakesFromCacheUsingId({
    int studentId,
    int textId,
  });

  /// Deletes all the [Mistake] from a specific collection.
  ///
  /// Throws [CacheException] if the [Collection] is not cached.
  Future<void> deleteCorrectionMistakesFromCache(
      MistakeModel mistakeModel);

  /// Caches the new [Mistake] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<MistakeModel> cacheNewMistake(MistakeModel mistakeModel);
}

class MistakeLocalDataSourceImpl implements MistakeLocalDataSource {
  final Database database;

  MistakeLocalDataSourceImpl({
    @required this.database,
  });

  @override
  Future<MistakeModel> cacheNewMistake(MistakeModel mistakeModel) async {
    try {
      final pk = await this.database.insertMistake(mistakeModel);
      return mistakeModel.copyWith(localId: pk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteCorrectionMistakesFromCache(
      MistakeModel mistakeModel) async {
    final int studentPk = mistakeModel.studentId;
    final int textPk = mistakeModel.textId;
    try {
      await this.database.deleteMistakesOfCorrection(
            textPk: textPk,
            studentPk: studentPk,
          );
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<MistakeModel>> getCorrectionMistakesFromCache(
      {StudentModel studentModel, TextModel textModel}) async {
    final int studentId = studentModel.localId;
    final int textId = textModel.localId;
    try {
      return await this.database.getMistakesOfCorrection(
            textPk: textId,
            studentPk: studentId,
          );
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<MistakeModel>> getCorrectionMistakesFromCacheUsingId({int studentId, int textId}) async {
    try {
      return await this.database.getMistakesOfCorrection(
            textPk: textId,
            studentPk: studentId,
          );
    } on SqliteException {
      throw CacheException();
    }
  }
}

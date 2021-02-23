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
  Future<List<MistakeModel>> getMistakesFromCache(
      CorrectionModel correctionModel);

  /// Gets the cached of [Correction]
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<CorrectionModel> getCorrectionFromCache({
    StudentModel studentModel,
    TextModel textModel,
  });

  /// Gets the cached list of [Mistake] of a specific correctiion (student and text).
  ///
  /// Returns an empty list if no [Mistake] is cache.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<MistakeModel>> getMistakesFromCacheUsingId(int correctionId);

  /// Gets  [Correction]
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<CorrectionModel> getCorrectionFromCacheUsingId({
    int studentId,
    int textId,
  });

  /// Deletes the [Correction]
  ///
  /// Throws [CacheException] if the [Correction] is not cached.
  Future<void> deleteCorrectionFromCache(CorrectionModel correctionModel);

  /// Caches the new [Mistake] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<MistakeModel> cacheNewMistake(MistakeModel mistakeModel);

  /// Caches the new [Correction] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<CorrectionModel> cacheNewCorrection(CorrectionModel correctionModel);
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
  Future<void> deleteCorrectionFromCache(
      CorrectionModel correctionModel) async {
    final int correctionPk = correctionModel.localId;
    try {
      await this.database.deleteMistakesOfCorrection(correctionPk);
      await this.database.deleteCorrection(correctionPk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<MistakeModel>> getMistakesFromCache(
      CorrectionModel correctionModel) async {
    final int correctionId = correctionModel.localId;
    try {
      return await this.database.getMistakesOfCorrection(correctionId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<MistakeModel>> getMistakesFromCacheUsingId(
      int correctionId) async {
    try {
      return await this.database.getMistakesOfCorrection(correctionId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<CorrectionModel> cacheNewCorrection(
      CorrectionModel correctionModel) async {
    try {
      final pk = await this.database.insertCorrection(correctionModel);
      return correctionModel.copyWith(localId: pk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<CorrectionModel> getCorrectionFromCache(
      {StudentModel studentModel, TextModel textModel}) async {
    final int studentId = studentModel.localId;
    final int textId = textModel.localId;
    try {
      return await this
          .database
          .getCorrection(studentId: studentId, textId: textId);
    } on SqliteException {
      throw CacheException();
    } on EmptyDataException {
      throw EmptyDataException();
    }
  }

  @override
  Future<CorrectionModel> getCorrectionFromCacheUsingId(
      {int studentId, int textId}) async {
    try {
      return await this
          .database
          .getCorrection(studentId: studentId, textId: textId);
    } on SqliteException {
      throw CacheException();
    } on EmptyDataException {
      throw EmptyDataException();
    }
  }
}

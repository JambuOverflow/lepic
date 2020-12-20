import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

abstract class SchoolLocalDataSource {
  /// Gets the cached list of [School].
  ///
  /// Returns an empty list if no [School] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<SchoolModel>> getSchoolsFromCache(UserModel userModel);

  /// Deletes the [School] passed.
  ///
  /// Throws [CacheException] if the [School] is not cached.
  Future<void> deleteSchoolFromCache(SchoolModel schoolModel);

  /// Caches the new [School] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<SchoolModel> cacheNewSchool(SchoolModel schoolModel);

  /// Updated in cache the [School] passed.
  ///
  /// Throws [CacheException] if [School] is not cached.
  Future<SchoolModel> updateCachedSchool(SchoolModel schoolModel);
}

class SchoolLocalDataSourceImpl implements SchoolLocalDataSource {
  final Database database;

  SchoolLocalDataSourceImpl({@required this.database});

  @override
  Future<SchoolModel> cacheNewSchool(SchoolModel schoolModel) async {
    try {
      bool nullToAbsent = true;
      final schoolCompanion = schoolModel.toCompanion(nullToAbsent);
      final classPk = await this.database.insertSchool(schoolCompanion);
      return SchoolModel(
          userId: schoolModel.userId,
          zipCode: schoolModel.zipCode,
          modality: schoolModel.modality,
          state: schoolModel.state,
          city: schoolModel.city,
          neighborhood: schoolModel.neighborhood,
          name: schoolModel.name,
          localId: classPk);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteSchoolFromCache(SchoolModel schoolModel) async {
    var pk = schoolModel.localId;
    try {
      var done = await this.database.deleteSchool(pk);
      if (done != 1) {
        throw SqliteException(787, "The table doesn't have this entry");
      }
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<SchoolModel>> getSchoolsFromCache(UserModel userModel) async {
    final userId = userModel.localId;
    try {
      return await this.database.getSchools(userId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<SchoolModel> updateCachedSchool(SchoolModel schoolModel) async {
    bool updated = await this.database.updateSchool(schoolModel);
    if (updated) {
      return schoolModel;
    } else {
      throw CacheException();
    }
  }
}

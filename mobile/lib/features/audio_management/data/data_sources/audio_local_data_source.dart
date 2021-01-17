import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';

abstract class AudioLocalDataSource {
  /// Gets the cached list of [Audio] from a student.
  ///
  /// Returns an empty list if no [Audio] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<List<AudioModel>> getAllAudiosOfStudentFromCache();

  /// Gets the cached list of [Audio].
  ///
  /// Returns an empty list if no [Audio] is cached.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<AudioModel> getAudioFromCache();

  /// Deletes the [Audio] passed.
  ///
  /// Throws [CacheException] if the [Audio] is not cached.
  Future<void> deleteAudioFromCache(AudioModel audioModel);

  /// Caches the new [Audio] passed.
  ///
  /// Throws [CacheException] if something wrong happens.
  Future<AudioModel> cacheNewAudio(AudioModel audioModel);

  /// Updates in cache the [Audio] passed.
  ///
  /// Throws [CacheException] if [Clasroom] is not cached.
  Future<AudioModel> updateCachedAudio(AudioModel audioModel);

  /// Updates in cache the [Audio] passed if the [Audio] already exists.
  /// Creates the [Audio] if it does not yet exists.
  /// Throws [CacheException] if something wrong happens.
  Future<AudioModel> cacheAudio(AudioModel audioModel);
}

/*
class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final Database database;
  final UserLocalDataSource userLocalDataSource;

  AudioLocalDataSourceImpl({
    @required this.database,
    @required this.userLocalDataSource,
  });

  @override
  Future<AudioModel> cacheNewAudio(
      AudioModel audioModel) async {
    try {
      bool nullToAbsent = true;
      final classCompanion = audioModel.toCompanion(nullToAbsent);
      final classPk = await this.database.insertAudio(classCompanion);

      return audioModel.copyWith(localId: classPk, deleted: false);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteAudioFromCache(AudioModel audioModel) async {
    AudioModel deletedAudioModel =
        audioModel.copyWith(deleted: true);
    try {
      await this.database.updateAudio(deletedAudioModel);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<List<AudioModel>> getAudiosFromCache() async {
    try {
      final tutorId = await userLocalDataSource.getUserId();
      return await this.database.getAudios(tutorId);
    } on SqliteException {
      throw CacheException();
    }
  }

  @override
  Future<AudioModel> cacheAudio(AudioModel audioModel) async {
    bool audioExists;
    if (audioModel.localId == null) {
      audioExists = false;
    } else {
      audioExists =
          await this.database.audioExists(audioModel.localId);
    }
    if (audioExists) {
      return updateCachedAudio(audioModel);
    } else {
      return cacheNewAudio(audioModel);
    }
  }

  @override
  Future<AudioModel> updateCachedAudio(
      AudioModel audioModel) async {
    try {
      await this.database.updateAudio(audioModel);
      return audioModel;
    } on SqliteException {
      throw CacheException();
    }
  }
}
*/

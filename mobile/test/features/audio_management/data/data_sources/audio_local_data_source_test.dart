import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/audio_management/data/data_sources/audio_local_data_source.dart';

import 'package:mockito/mockito.dart';
import 'package:moor/ffi.dart';
import 'package:matcher/matcher.dart';

class MockDatabase extends Mock implements Database {}

Future<void> main() {
  MockDatabase mockDatabase;
  AudioLocalDataSourceImpl audioLocalDataSourceImpl;

  final tValidPk = 1;

  Uint8List audioData;

  final tAudioInputModel1 = AudioModel(
    title: '1',
    audioData: audioData,
    studentId: 1,
    textId: 1,
  );
  final tAudioInputModel2 = tAudioInputModel1.copyWith(title: "2");

  final tAudioOutputModel1 = tAudioInputModel1.copyWith(localId: 1);

  final tStudentModel = StudentModel(
    firstName: "",
    localId: 1,
    lastName: "",
    classroomId: 1,
  );

  final tTextModel = TextModel(
    title: "",
    body: "",
    studentId: 1,
    localId: 1,
    tutorId: 1,
  );

  final tAudioModels = [tAudioInputModel1, tAudioInputModel2];

  setUp(() async {
    mockDatabase = MockDatabase();

    audioLocalDataSourceImpl = AudioLocalDataSourceImpl(database: mockDatabase);
  });

  group("cacheAudio", () {
    test("should correctly cache and return a valid audio", () async {
      when(mockDatabase.insertAudio(tAudioInputModel1))
          .thenAnswer((_) async => tValidPk);

      final result =
          await audioLocalDataSourceImpl.cacheNewAudio(tAudioInputModel1);
      verify(mockDatabase.insertAudio(tAudioInputModel1));
      expect(result, tAudioOutputModel1);
    });

    test("should throw CacheException when trying to insert an invalid audio",
        () {
      when(mockDatabase.insertAudio(tAudioInputModel1))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async =>
              await audioLocalDataSourceImpl.cacheNewAudio(tAudioInputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("deleteAudio", () {
    test("should correctly delete a cached audio", () async {
      when(mockDatabase.deleteAudio(1)).thenAnswer((_) async => 1);

      await audioLocalDataSourceImpl.deleteAudioFromCache(tAudioOutputModel1);
      verify(mockDatabase.deleteAudio(1));
    });

    test("should throw CacheException when trying to delete an ivalid audio",
        () {
      when(mockDatabase.deleteAudio(tValidPk))
          .thenThrow(SqliteException(787, ""));
      expect(
          () async => await audioLocalDataSourceImpl
              .deleteAudioFromCache(tAudioOutputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getAudioOfStudent", () {
    test("should correctly return a list of audios", () async {
      when(mockDatabase.getAllAudiosOfStudent(1))
          .thenAnswer((_) async => tAudioModels);

      final result = await audioLocalDataSourceImpl
          .getAllAudiosOfStudentFromCache(tStudentModel);

      verify(mockDatabase.getAllAudiosOfStudent(1));
      final testResult = listEquals(result, tAudioModels);
      equals(testResult);
    });

    test("should correctly return an empty list", () async {
      when(mockDatabase.getAllAudiosOfStudent(1)).thenAnswer((_) async => []);

      final result = await audioLocalDataSourceImpl
          .getAllAudiosOfStudentFromCache(tStudentModel);

      verify(mockDatabase.getAllAudiosOfStudent(1));
      final testResult = listEquals(result, []);
      equals(testResult);
    });

    test("should throw a CacheException", () async {
      when(mockDatabase.getAllAudiosOfStudent(1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await audioLocalDataSourceImpl
              .getAllAudiosOfStudentFromCache(tStudentModel),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getAudio", () {
    test("should correctly one audio", () async {
      when(mockDatabase.getAudio(studentPk: 1, textPk: 1))
          .thenAnswer((_) async => tAudioOutputModel1);

      final result = await audioLocalDataSourceImpl.getAudioFromCache(
        studentModel: tStudentModel,
        textModel: tTextModel,
      );

      verify(mockDatabase.getAudio(studentPk: 1, textPk: 1));
      expect(result, tAudioOutputModel1);
    });

    test("should throw a EmptyDataException", () async {
      when(mockDatabase.getAudio(studentPk: 1, textPk: 1))
          .thenThrow(EmptyDataException());

      expect(
          () async => await audioLocalDataSourceImpl.getAudioFromCache(
                studentModel: tStudentModel,
                textModel: tTextModel,
              ),
          throwsA(TypeMatcher<EmptyDataException>()));
    });
  });

  group("updateAudio", () {
    test("should correctly update a cached audio", () async {
      when(mockDatabase.updateAudio(tAudioOutputModel1))
          .thenAnswer((_) async => null);

      await audioLocalDataSourceImpl.updateCachedAudio(tAudioOutputModel1);
      verify(mockDatabase.updateAudio(tAudioOutputModel1));
    });

    test("should throw a cache expection if the update was not completed",
        () async {
      when(mockDatabase.updateAudio(tAudioOutputModel1))
          .thenThrow(SqliteException(787, ""));

      expect(
          () async => await audioLocalDataSourceImpl
              .updateCachedAudio(tAudioOutputModel1),
          throwsA(TypeMatcher<CacheException>()));
    });
  });
}

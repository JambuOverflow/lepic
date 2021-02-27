import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/audio_entity_model_converter.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/data/data_sources/audio_local_data_source.dart';
import 'package:mobile/features/audio_management/data/repositories/audio_repository_impl.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';
import 'package:moor/moor.dart';

class MockAudioLocalDataSource extends Mock implements AudioLocalDataSource {}

class MockAudioEntityModelConverter extends Mock
    implements AudioEntityModelConverter {}

class MockTextEntityModelConvert extends Mock
    implements TextEntityModelConverter {}

void main() {
  MockAudioLocalDataSource mockLocalDataSource;
  AudioRepositoryImpl repository;
  MockAudioEntityModelConverter mockAudioEntityModelConverter;
  MockTextEntityModelConvert mocktextEntityModelConverter;

  Uint8List audio_data;

  final tAudioOutput = AudioEntity(
    title: '1',
    localId: 2,
    data: audio_data,
    studentId: 1,
    textId: 1,
  );

  final tAudioInput = AudioEntity(
    title: '1',
    data: audio_data,
    studentId: 1,
    textId: 1,
  );

  final tAudioModelInput = AudioModel(
    title: '1',
    audioData: audio_data,
    studentId: 1,
    textId: 1,
  );

  final tStudent = Student(
    firstName: '',
    lastName: '',
    classroomId: 1,
    id: 1,
  );

  final tStudentModel = StudentModel(
    localId: 1,
    firstName: "",
    lastName: "",
    classroomId: 1,
  );

  final tTextModel = TextModel(
    localId: 1,
    title: "",
    body: "",
    tutorId: 1,
    studentId: 1,
  );

  final tText = MyText(
    localId: 1,
    title: "",
    body: "",
    studentId: 1,
  );

  final tAudioModelOutput = tAudioModelInput.copyWith(localId: 2);

  final tAudiosModels = [tAudioModelInput, tAudioModelInput];
  final tAudios = [tAudioInput, tAudioInput];

  setUp(() {
    mockLocalDataSource = MockAudioLocalDataSource();
    mockAudioEntityModelConverter = MockAudioEntityModelConverter();
    mocktextEntityModelConverter = MockTextEntityModelConvert();

    repository = AudioRepositoryImpl(
        localDataSource: mockLocalDataSource,
        audioEntityModelConverter: mockAudioEntityModelConverter,
        textEntityModelConverter: mocktextEntityModelConverter);
    when(mockAudioEntityModelConverter.entityToModel(tAudioInput))
        .thenAnswer((_) => tAudioModelInput);
    when(mockAudioEntityModelConverter.entityToModel(tAudioOutput))
        .thenAnswer((_) => tAudioModelOutput);
    when(mockAudioEntityModelConverter.modelToEntity(tAudioModelOutput))
        .thenAnswer((_) => tAudioOutput);
    when(mockAudioEntityModelConverter.modelToEntity(tAudioModelInput))
        .thenAnswer((_) => tAudioInput);
  });

  group('createAudio', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewAudio(tAudioModelInput))
          .thenThrow(CacheException());

      final result = await repository.createAudio(tAudioInput);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created audio', () async {
      when(mockLocalDataSource.cacheNewAudio(tAudioModelInput))
          .thenAnswer((_) async => tAudioModelOutput);

      final result = await repository.createAudio(tAudioInput);

      verify(mockLocalDataSource.cacheNewAudio(tAudioModelInput));
      expect(result, Right(tAudioOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('delete', () {
    test('should delete a audio and return Right', () async {
      when(mockLocalDataSource.deleteAudioFromCache(tAudioModelOutput))
          .thenAnswer((_) async => null);

      final expected = await repository.deleteAudio(tAudioOutput);

      expect(expected, Right(null));

      verify(mockLocalDataSource.deleteAudioFromCache(tAudioModelOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteAudioFromCache(tAudioModelOutput))
          .thenThrow(CacheException());

      final result = await repository.deleteAudio(tAudioOutput);
      verify(mockLocalDataSource.deleteAudioFromCache(tAudioModelOutput));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('update', () {
    test('should return a audio when updateAudio is called', () async {
      when(mockLocalDataSource.updateCachedAudio(tAudioModelOutput))
          .thenAnswer((_) async => tAudioModelOutput);

      final result = await repository.updateAudio(tAudioOutput);

      verify(mockLocalDataSource.updateCachedAudio(tAudioModelOutput));
      expect(result, Right(tAudioOutput));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedAudio(tAudioModelOutput))
          .thenThrow(CacheException());

      final result = await repository.updateAudio(tAudioOutput);

      verify(mockLocalDataSource.updateCachedAudio(tAudioModelOutput));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getAudiosOfClassroom', () {
    test('should return a list of audios when getAudiosofClassroom is called',
        () async {
      when(mockLocalDataSource.getAllAudiosOfStudentFromCache(tStudentModel))
          .thenAnswer((_) async => tAudiosModels);

      final result = await repository.getAllAudiosFromStudent(tStudent);
      final List<AudioEntity> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tAudios);
      expect(true, resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getAllAudiosOfStudentFromCache(tStudentModel))
          .thenThrow(CacheException());

      final result = await repository.getAllAudiosFromStudent(tStudent);

      expect(result, Left(CacheFailure()));
    });
  });

  group('getAudio', () {
    test('should return a list of audios when getAudios is called', () async {
      when(mockLocalDataSource.getAudioFromCache(
        studentModel: tStudentModel,
        textModel: tTextModel,
      )).thenAnswer((_) async => tAudioModelOutput);
      when(mocktextEntityModelConverter.mytextEntityToModel(tText))
          .thenAnswer((_) async => tTextModel);

      final result = await repository.getAudio(text: tText, student: tStudent);

      expect(result, Right(tAudioOutput));
      verify(mockLocalDataSource.getAudioFromCache(
        studentModel: tStudentModel,
        textModel: tTextModel,
      ));
      verify(
        mocktextEntityModelConverter.mytextEntityToModel(tText),
      );
    });

    test('should return null when a CacheException is throw',
        () async {
      when(mocktextEntityModelConverter.mytextEntityToModel(tText))
          .thenAnswer((_) async => tTextModel);
      when(mockLocalDataSource.getAudioFromCache(
        studentModel: tStudentModel,
        textModel: tTextModel,
      )).thenThrow(EmptyDataException());

      final result = await repository.getAudio(text: tText, student: tStudent);

      expect(result, Left(EmptyDataFailure()));
    });
  });

  group('getAudioFromId', () {
    test('should return a list of audios when getAudios is called', () async {
      when(mockLocalDataSource.getAudioFromCacheWithId(
        studentId: 1,
        textId: 1,
      )).thenAnswer((_) async => tAudioModelOutput);
      when(mocktextEntityModelConverter.mytextEntityToModel(tText))
          .thenAnswer((_) async => tTextModel);

      final result = await repository.getAudioFromId(textId: 1, 
      studentId: 1);

      expect(result, Right(tAudioOutput));
      verify(mockLocalDataSource.getAudioFromCacheWithId(
        studentId: 1,
        textId: 1,
      ));
      
    });

    test('should return null when a CacheException is throw',
        () async {
      when(mocktextEntityModelConverter.mytextEntityToModel(tText))
          .thenAnswer((_) async => tTextModel);
      when(mockLocalDataSource.getAudioFromCacheWithId(
        studentId: 1,
        textId: 1,
      )).thenThrow(EmptyDataException());

      final result = await repository.getAudioFromId(textId: 1, studentId: 1);

      expect(result, Left(EmptyDataFailure()));
    });
  });
}

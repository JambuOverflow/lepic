import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/data/data_sources/text_local_data_source.dart';
import 'package:mobile/features/text_management/data/models/text_model.dart';
import 'package:mobile/features/text_management/data/repositories/text_repository_impl.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mockito/mockito.dart';

class MockTextLocalDataSource extends Mock implements TextLocalDataSource {}

class MockClassroomEntityModelConverter extends Mock
    implements ClassroomEntityModelConverter {}

void main() {
  MockTextLocalDataSource mockLocalDataSource;
  TextRepositoryImpl repository;
  ClassroomModel tClassroomModel;
  MockClassroomEntityModelConverter mockClassroomEntityModelConverter;

  final tClassroom = Classroom(
    grade: 1,
    name: "A",
    id: 1,
  );

  final tText = MyText(
    title: "a",
    body: "b",
    classId: 1,
  );

  final tTextModel = textEntityToModel(tText);

  final tTextsModels = [tTextModel, tTextModel];
  final tTexts = [tText, tText];

  setUp(() {
    mockLocalDataSource = MockTextLocalDataSource();
    mockClassroomEntityModelConverter = MockClassroomEntityModelConverter();

    tClassroomModel = ClassroomModel(grade: 1, localId: 1, name: "A");

    repository = TextRepositoryImpl(
      localDataSource: mockLocalDataSource,
      classroomEntityModelConverter: mockClassroomEntityModelConverter,
    );
    when(mockClassroomEntityModelConverter.classroomEntityToModel(tClassroom))
        .thenAnswer((_) async => tClassroomModel);
  });

  group('createText', () {
    test('should return CacheFailure when cache is unsuccessful', () async {
      when(mockLocalDataSource.cacheNewText(tTextModel))
          .thenThrow(CacheException());

      final result = await repository.createText(tText);

      expect(result, Left(CacheFailure()));
    });

    test('should cache newly created text', () async {
      when(mockLocalDataSource.cacheNewText(tTextModel))
          .thenAnswer((_) async => tTextModel);

      final result = await repository.createText(tText);

      verify(mockLocalDataSource.cacheNewText(tTextModel));
      expect(result, Right(tText));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('delete', () {
    test('should delete a text and return Right', () async {
      when(mockLocalDataSource.deleteTextFromCache(tTextModel))
          .thenAnswer((_) async => Right(null));

      final expected = await repository.deleteText(tText);

      expect(expected, Right(null));

      verify(mockLocalDataSource.deleteTextFromCache(tTextModel));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.deleteTextFromCache(tTextModel))
          .thenThrow(CacheException());

      final result = await repository.deleteText(tText);
      verify(mockLocalDataSource.deleteTextFromCache(tTextModel));

      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('update', () {
    test('should return a text when updateText is called', () async {
      when(mockLocalDataSource.updateCachedText(tTextModel))
          .thenAnswer((_) async => tTextModel);

      final result = await repository.updateText(tText);

      verify(mockLocalDataSource.updateCachedText(tTextModel));
      expect(result, Right(tText));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.updateCachedText(tTextModel))
          .thenThrow(CacheException());

      final result = await repository.updateText(tText);

      verify(mockLocalDataSource.updateCachedText(tTextModel));
      expect(result, Left(CacheFailure()));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getTextsOfClassroom', () {
    test('should return a list of texts when getTextsofClassroom is called', () async {
      when(mockLocalDataSource.getTextsOfClassroomFromCache(tClassroomModel))
          .thenAnswer((_) async => tTextsModels);

      final result = await repository.getTextsOfClassroom(tClassroom);
      final List<MyText> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tTexts);
      equals(resultTest);
    });

    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getTextsOfClassroomFromCache(tClassroomModel))
          .thenThrow(CacheException());

      final result = await repository.getTextsOfClassroom(tClassroom);

      expect(result, Left(CacheFailure()));
    });
  });

  group('getTexts', () {
    test('should return a list of texts when getTexts is called', () async {
      when(mockLocalDataSource.getTextsFromCache())
          .thenAnswer((_) async => tTextsModels);

      final result = await repository.getTexts();
      final List<MyText> resultList = result.getOrElse(() => null);

      final resultTest = listEquals(resultList, tTexts);
      equals(resultTest);
    });
    
    test('should return a CacheFailure when a CacheException is throw',
        () async {
      when(mockLocalDataSource.getTextsFromCache())
          .thenThrow(CacheException());

      final result = await repository.getTexts();

      expect(result, Left(CacheFailure()));
    });
  });
}

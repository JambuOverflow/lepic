import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/classroom_entity_model_converter.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockUserLocalDataSourceImpl mockUserLocalDataSourceImpl;
  ClassroomEntityModelConverter classroomEntityModelConverter;

  final tTime = DateTime.utc(2018, 1, 1, 1, 1);

  final tClassModel = ClassroomModel(
    grade: 1,
    localId: 2,
    title: "A",
    tutorId: 3,
    deleted: false,
    lastUpdated: tTime,
    clientLastUpdated: tTime,
  );

  final tClassEntity = Classroom(
    grade: 1,
    id: 2,
    name: "A",
    deleted: false,
    lastUpdated: tTime,
    clientLastUpdated: tTime,
  );

  setUp(() {
    mockUserLocalDataSourceImpl = MockUserLocalDataSourceImpl();

    classroomEntityModelConverter = ClassroomEntityModelConverter(
        userLocalDataSource: mockUserLocalDataSourceImpl);
  });

  group('modelToEntity', () {
    test('should return a Classroom entity with proper data', () async {
      final result =
          classroomEntityModelConverter.classroomModelToEntity(tClassModel);

      expect(result, tClassEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () async {
      when(mockUserLocalDataSourceImpl.getUserId()).thenAnswer((_) async => 3);
      final result = await classroomEntityModelConverter
          .classroomEntityToModel(tClassEntity);

      expect(result, tClassModel);
    });

    test('should return a Classroom with utc 0 when no ...', () async {
      final tClassEntity = Classroom(lastUpdated: null);

      final tClassModel = ClassroomModel(
        lastUpdated: DateTime(0).toUtc(),
        deleted: false,
        tutorId: 3,
      );

      when(mockUserLocalDataSourceImpl.getUserId()).thenAnswer((_) async => 3);
      final result = await classroomEntityModelConverter
          .classroomEntityToModel(tClassEntity);

      expect(result, tClassModel);
    });
  });
}

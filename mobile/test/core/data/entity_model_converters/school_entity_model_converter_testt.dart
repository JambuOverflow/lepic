import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/school_entity_model_converter.dart';
import 'package:mobile/features/school_management/domain/entities/school.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockUserLocalDataSourceImpl mockUserLocalDataSourceImpl;
  SchoolEntityModelConverter schoolEntityModelConverter;

  final tTime = DateTime.utc(2018, 1, 1, 1, 1);

  final tSchoolModel = SchoolModel(
    localId: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.municipal,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  final tSchoolEntity = School(
    id: 1,
    userId: 1,
    name: 'A',
    zipCode: 0,
    modality: Modality.municipal,
    state: 'B',
    city: 'C',
    neighborhood: 'D',
  );

  setUp(() {
    mockUserLocalDataSourceImpl = MockUserLocalDataSourceImpl();

    schoolEntityModelConverter = SchoolEntityModelConverter(
        userLocalDataSource: mockUserLocalDataSourceImpl);
  });

  group('modelToEntity', () {
    test('should return a School entity with proper data', () async {
      final result =
          schoolEntityModelConverter.schoolModelToEntity(tSchoolModel);

      expect(result, tSchoolEntity);
    });
  });

  group('entityToModel', () {
    test('should return a School model with proper data', () async {
      when(mockUserLocalDataSourceImpl.getUserId()).thenAnswer((_) async => 3);
      final result = await schoolEntityModelConverter
          .schoolEntityToModel(tSchoolEntity);

      expect(result, tSchoolModel);
    });

  });
}

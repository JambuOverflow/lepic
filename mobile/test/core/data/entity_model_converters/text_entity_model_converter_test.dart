import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database.dart';
import 'package:mobile/core/data/entity_model_converters/text_entity_model_converter.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/user_management/data/data_sources/user_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockUserLocalDataSourceImpl extends Mock
    implements UserLocalDataSourceImpl {}

void main() {
  MockUserLocalDataSourceImpl mockUserLocalDataSourceImpl;
  TextEntityModelConverter textEntityModelConverter;

  setUp(() {
    mockUserLocalDataSourceImpl = MockUserLocalDataSourceImpl();

    textEntityModelConverter = TextEntityModelConverter(
        userLocalDataSource: mockUserLocalDataSourceImpl);
  });

  final tTextModel = TextModel(
    body: "A",
    title: "B",
    localId: 1,
    tutorId: 2,
    classId: 3,
  );

  final tTextEntity = MyText(
    body: "A",
    title: "B",
    localId: 1,
    classId: 3,
  );

  group('modelToEntity', () {
    test('should return a Text entity with proper data', () async {
      final result = textEntityModelConverter.mytextModelToEntity(tTextModel);

      expect(result, tTextEntity);
    });
  });

  group('entityToModel', () {
    test('should return a Classroom model with proper data', () async {
      when(mockUserLocalDataSourceImpl.getUserId()).thenAnswer((_) async => 2);
      final result =
          await textEntityModelConverter.mytextEntityToModel(tTextEntity);

      expect(result, tTextModel);
    });
  });
}

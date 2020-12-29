import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';
import 'package:mobile/features/text_management/domain/use_cases/update_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  UpdateText useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = UpdateText(repository: mockTextRepository);
  });

  final tText = MyText(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  test('should return a correct response when updating a Text', () async {
    when(mockTextRepository.updateText(tText))
        .thenAnswer((_) async => Right(tText));

    final result = await useCase(TextParams(text: tText));

    expect(result, Right(tText));
    verify(mockTextRepository.updateText(tText));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/create_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  CreateTextUseCase useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = CreateTextUseCase(repository: mockTextRepository);
  });

  final tText = MyText(
    title: "Test Title",
    body: "Test Body",
    studentId: 1,
  );

  test('should return the created text when creating it', () async {
    when(mockTextRepository.createText(tText))
        .thenAnswer((_) async => Right(tText));

    final result = await useCase(TextParams(text: tText));

    expect(result, Right(tText));
    verify(mockTextRepository.createText(tText));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

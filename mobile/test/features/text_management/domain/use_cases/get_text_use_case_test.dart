import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  GetTextUseCase useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = GetTextUseCase(repository: mockTextRepository);
  });

  final tText = MyText(
    title: "Test Title",
    body: "Test Body",
    studentId: 1,
    localId: 1,
  );

  test('should return the correct text', () async {
    when(mockTextRepository.getTextByID(1))
        .thenAnswer((_) async => Right(tText));

    final result = await useCase(1);

    expect(result, Right(tText));
    verify(mockTextRepository.getTextByID(1));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

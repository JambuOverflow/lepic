import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/delete_text_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/text_params.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  DeleteText useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = DeleteText(repository: mockTextRepository);
  });


 final tText = Text(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  test('should return nothing when deleting a Text', () async {

    await useCase(TextParams(text: tText));

    verify(mockTextRepository.deleteText(tText));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

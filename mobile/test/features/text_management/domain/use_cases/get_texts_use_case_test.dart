import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_use_case.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  GetTexts useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = GetTexts(repository: mockTextRepository);
  });

 

  final tText1 = MyText(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  final tText2 = MyText(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  final List<MyText> tTwoTexts = [tText1, tText2];
  final List<MyText> tEmptyTexts = [];

  test('should return an empty list of texts if there is no text', () async {
    when(mockTextRepository.getTexts())
        .thenAnswer((_) async => Right(tEmptyTexts));

    final result = await useCase(NoParams());

    expect(result, Right(tEmptyTexts));
    verify(mockTextRepository.getTexts());
    verifyNoMoreInteractions(mockTextRepository);
  });

  test('should return list of texts', () async {
    when(mockTextRepository.getTexts())
        .thenAnswer((_) async => Right(tTwoTexts));

    final result = await useCase(NoParams());

    expect(result, Right(tTwoTexts));
    verify(mockTextRepository.getTexts());
    verifyNoMoreInteractions(mockTextRepository);
  });
}

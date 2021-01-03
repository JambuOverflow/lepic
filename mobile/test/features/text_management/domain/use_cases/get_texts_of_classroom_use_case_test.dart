import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_texts_of_classroom_use_case.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  GetTextsOfClassroom useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = GetTextsOfClassroom(repository: mockTextRepository);
  });

  final tClassroom = Classroom(
    grade: 1,
    name: "A",
    id: 1,
  );

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
    when(mockTextRepository.getTextsOfClassroom(tClassroom))
        .thenAnswer((_) async => Right(tEmptyTexts));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tEmptyTexts));
    verify(mockTextRepository.getTextsOfClassroom(tClassroom));
    verifyNoMoreInteractions(mockTextRepository);
  });

  test('should return list of texts', () async {
    when(mockTextRepository.getTextsOfClassroom(tClassroom))
        .thenAnswer((_) async => Right(tTwoTexts));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tTwoTexts));
    verify(mockTextRepository.getTextsOfClassroom(tClassroom));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

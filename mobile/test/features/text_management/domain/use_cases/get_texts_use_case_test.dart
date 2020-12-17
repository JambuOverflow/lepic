import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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

  final tClassroom = Classroom(
    tutorId: 1,
    grade: 1,
    name: "A",
    id: 1,
  );

  final tText1 = Text(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  final tText2 = Text(
    title: "Test Title",
    body: "Test Body",
    classId: 1,
  );

  final List<Text> tTwoTexts = [tText1, tText2];
  final List<Text> tEmptyTexts = [];

  test('should return an empty list of texts if there is no text',
      () async {
    when(mockTextRepository.getTexts(tClassroom))
        .thenAnswer((_) async => Right(tEmptyTexts));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tEmptyTexts));
    verify(mockTextRepository.getTexts(tClassroom));
    verifyNoMoreInteractions(mockTextRepository);
  });

  test('should return list of texts', () async {
    when(mockTextRepository.getTexts(tClassroom))
        .thenAnswer((_) async => Right(tTwoTexts));

    final result = await useCase(ClassroomParams(classroom: tClassroom));

    expect(result, Right(tTwoTexts));
    verify(mockTextRepository.getTexts(tClassroom));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

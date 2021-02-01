import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/repositories/text_repository.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_student_texts_use_case.dart';
import 'package:mockito/mockito.dart';

class MockTextRepository extends Mock implements TextRepository {}

void main() {
  GetStudentTextsUseCase useCase;
  MockTextRepository mockTextRepository;

  setUp(() {
    mockTextRepository = MockTextRepository();
    useCase = GetStudentTextsUseCase(repository: mockTextRepository);
  });

  final tStudent = Student(firstName: 'a', lastName: 'b', classroomId: 1);

  final tText1 = MyText(
    title: "Test Title",
    body: "Test Body",
    studentId: 1,
  );

  final tText2 = MyText(
    title: "Test Title",
    body: "Test Body",
    studentId: 1,
  );

  final List<MyText> tTwoTexts = [tText1, tText2];
  final List<MyText> tEmptyTexts = [];

  test('should return an empty list of texts if there is no text', () async {
    when(mockTextRepository.getStudentTexts(tStudent))
        .thenAnswer((_) async => Right(tEmptyTexts));

    final result = await useCase(StudentParams(student: tStudent));

    expect(result, Right(tEmptyTexts));
    verify(mockTextRepository.getStudentTexts(tStudent));
    verifyNoMoreInteractions(mockTextRepository);
  });

  test('should return list of texts', () async {
    when(mockTextRepository.getStudentTexts(tStudent))
        .thenAnswer((_) async => Right(tTwoTexts));

    final result = await useCase(StudentParams(student: tStudent));

    expect(result, Right(tTwoTexts));
    verify(mockTextRepository.getStudentTexts(tStudent));
    verifyNoMoreInteractions(mockTextRepository);
  });
}

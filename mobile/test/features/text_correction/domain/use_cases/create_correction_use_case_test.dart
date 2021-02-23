import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/create_correction_use_case.dart';
import 'package:mockito/mockito.dart';

class MockCorrectionRepository extends Mock implements CorrectionRepository {}

void main() {
  CreateCorrectionUseCase useCase;
  MockCorrectionRepository mockCorrectionRepository;

  setUp(() {
    mockCorrectionRepository = MockCorrectionRepository();
    useCase = CreateCorrectionUseCase(repository: mockCorrectionRepository);
  });

  final List<Mistake> mistakes= [Mistake(localId: 1, wordIndex: 0, commentary: "ola")];

  final tCorrection = Correction(
    studentId: 1,
    textId: 2,
    mistakes: mistakes,
  );

  test('should return a correct response when creating a correction', () async {
    when(mockCorrectionRepository.createCorrection(tCorrection))
        .thenAnswer((_) async => Right(tCorrection));

    final result = await useCase(CorrectionParams(correction: tCorrection));

    expect(result, Right(tCorrection));
    verify(mockCorrectionRepository.createCorrection(tCorrection));
    verifyNoMoreInteractions(mockCorrectionRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/update_correction_use_case.dart';
import 'package:mockito/mockito.dart';

class MockCorrectionRepository extends Mock implements CorrectionRepository {}

void main() {
  UpdateCorrection useCase;
  MockCorrectionRepository mockCorrectionRepository;

  setUp(() {
    mockCorrectionRepository = MockCorrectionRepository();
    useCase = UpdateCorrection(repository: mockCorrectionRepository);
  });

  final Map<int, String> mistakes = {0: "ola"};

  final tCorrection = Correction(
    localId: 1,
    studentId: 1,
    textId: 2,
    mistakes: mistakes,
  );

  test('should return a correct response when updating a correction', () async {
    when(mockCorrectionRepository.updateCorrection(tCorrection))
        .thenAnswer((_) async => Right(tCorrection));

    final result = await useCase(CorrectionParams(correction: tCorrection));

    expect(result, Right(tCorrection));
    verify(mockCorrectionRepository.updateCorrection(tCorrection));
    verifyNoMoreInteractions(mockCorrectionRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mockito/mockito.dart';

class MockCorrectionRepository extends Mock implements CorrectionRepository {}

void main() {
  GetCorrectionFromIdUseCase useCase;
  MockCorrectionRepository mockCorrectionRepository;

  setUp(() {
    mockCorrectionRepository = MockCorrectionRepository();
    useCase = GetCorrectionFromIdUseCase(repository: mockCorrectionRepository);
  });

  final List<Mistake> mistakes= [Mistake(localId: 1, wordIndex: 0, commentary: "ola")];

  final tCorrection1 = Correction(
    audioId: 2,
    mistakes: mistakes,
  );

  test('should return list of corrections', () async {
    when(mockCorrectionRepository.getCorrectionFromId(1))
        .thenAnswer((_) async => Right(tCorrection1));

    final result = await useCase(AudioIdParams(1));

    expect(result, Right(tCorrection1));
    verify(mockCorrectionRepository.getCorrectionFromId(1));
    verifyNoMoreInteractions(mockCorrectionRepository);
  });
}

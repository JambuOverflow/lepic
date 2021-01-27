import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_mistaken_words_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/entities/mistake.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';


void main() {
  GetNumberOfMistakenWordsUseCase useCase;

  setUp(() {
    useCase = GetNumberOfMistakenWordsUseCase();
  });

    final List<Mistake> mistakes = [Mistake(localId: 1, wordIndex: 0, commentary: "ola")];
  
    final tCorrection = Correction(
      studentId: 1,
      textId: 2,
      mistakes: mistakes,
    );
  
    test('should return one indicating the number of mistaken words', () async {
  
      final result = await useCase(CorrectionParams(correction: tCorrection));
  
      expect(result, Right(1));
    });
  }
  
  

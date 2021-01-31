import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

class GetNumberOfCorrectWordsReadPerMinuteUseCase
    implements UseCase<double, AudioParams> {
  final GetTextUseCase getTextUseCase;
  final GetCorrectionFromIdUseCase getCorrectionFromIdUseCase;

  GetNumberOfCorrectWordsReadPerMinuteUseCase({
    @required this.getTextUseCase,
    @required this.getCorrectionFromIdUseCase,
  });

  @override
  Future<Either<Failure, double>> call(AudioParams params) async {
    try {
      final int numberOfwords = await _getNumberOfWords(params);
      final int numberMistakes = await _getNumberOfMistakes(params);
      final Duration audioDuration = params.audio.audioDuration;

      return Right((numberOfwords - numberMistakes) / audioDuration.inMinutes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<int> _getNumberOfMistakes(AudioParams params) async {
    final int studentId = params.audio.studentId;
      final int textId = params.audio.textId;
    final CorrectionIdParams correctionIdParams = CorrectionIdParams(
      textId: textId,
      studentId: studentId,
    );
    final correctionOutput =
        await getCorrectionFromIdUseCase(correctionIdParams);

    return correctionOutput.fold((l) {
      throw CacheException();
    }, (r) {
      return r.numberOfMistakes;
    });
  }

  Future<int> _getNumberOfWords(AudioParams params) async {
    final textEither = await getTextUseCase(params.audio.textId);
    return textEither.fold((l) {
      throw CacheException();
    }, (r) {
      return r.numberOfWords;
    });
  }
}

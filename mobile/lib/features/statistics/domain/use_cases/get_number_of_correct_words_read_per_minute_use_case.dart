import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_audio_duration_in_seconds_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_mistaken_words_use_case.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

class GetNumberOfCorrectWordsReadPerMinuteUseCase
    implements UseCase<double, AudioParams> {
  final GetTextUseCase getTextUseCase;
  final GetAudioDurationInMinutesUseCase getAudioDurationInMinutesUseCase;
  final GetNumberOfMistakenWordsUseCase getNumberOfMistakenWordsUseCase;
  final GetCorrectionFromIdUseCase getCorrectionFromIdUseCase;

  GetNumberOfCorrectWordsReadPerMinuteUseCase({
    @required this.getTextUseCase,
    @required this.getAudioDurationInMinutesUseCase,
    @required this.getNumberOfMistakenWordsUseCase,
    @required this.getCorrectionFromIdUseCase,
  });

  @override
  Future<Either<Failure, double>> call(AudioParams params) async {
    final output = await getTextUseCase(params.audio.textId);
    int number_words;
    int audioMinutes;
    if (output.isRight()) {
      final MyText text = output.getOrElse(() => null);
      number_words = text.body.split(" ").length;
    }

    final int studentId = params.audio.studentId;
    final int textId = params.audio.textId;

    final CorrectionIdParams correctionIdParams = CorrectionIdParams(
      textId: textId,
      studentId: studentId,
    );
    final correctionOutput =
        await getCorrectionFromIdUseCase(correctionIdParams);
    Correction correction;
    if (correctionOutput.isRight()) {
      correction = correctionOutput.getOrElse(() => null);
    }

    final mistakenOutput = await getNumberOfMistakenWordsUseCase(
        CorrectionParams(correction: correction));
    int numberMistakenWords;
    if (mistakenOutput.isRight()) {
      numberMistakenWords = mistakenOutput.getOrElse(() => null);
    }

    final audioMinutesEither = await getAudioDurationInMinutesUseCase(params);
    if (audioMinutesEither.isRight()) {
      audioMinutes = audioMinutesEither.getOrElse(() => null);
    }
    final double result = (number_words - numberMistakenWords) / audioMinutes;
    return Right(result);
  }
}

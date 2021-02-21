import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

class GetNumberOfCorrectWordsReadPerMinuteUseCase
    implements UseCase<double, CorrectionParams> {
  final GetTextUseCase getTextUseCase;
  final GetAudioFromIdUseCase getAudioFromIdUseCase;

  GetNumberOfCorrectWordsReadPerMinuteUseCase({
    @required this.getTextUseCase,
    @required this.getAudioFromIdUseCase,
  });

  @override
  Future<Either<Failure, double>> call(CorrectionParams params) async {
    try {
      final int numberOfwords = await _getNumberOfWords(params);
      final int numberMistakes = params.correction.numberOfMistakes;

      final Duration audioDuration = await _getAudioDuration(params);

      return Right((numberOfwords - numberMistakes) / audioDuration.inMinutes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Duration> _getAudioDuration(CorrectionParams params) async {
    final int studentId = params.correction.studentId;
    final int textId = params.correction.textId;
    final CorrectionIdParams correctionIdParams = CorrectionIdParams(
      textId: textId,
      studentId: studentId,
    );
    final audioOutput = await getAudioFromIdUseCase(correctionIdParams);
    return audioOutput.fold((l) {
      throw CacheException();
    }, (r) {
      return r.audioDuration;
    });
  }

  Future<int> _getNumberOfWords(CorrectionParams params) async {
    final textEither = await getTextUseCase(params.correction.textId);
    return textEither.fold((l) {
      throw CacheException();
    }, (r) {
      return r.numberOfWords;
    });
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/domain/use_cases/get_text_use_case.dart';

class GetNumberOfWordsReadPerMinuteUseCase
    implements UseCase<double, AudioParams> {
  final GetTextUseCase getTextUseCase;

  GetNumberOfWordsReadPerMinuteUseCase({
    @required this.getTextUseCase,
  });

  @override
  Future<Either<Failure, double>> call(AudioParams params) async {
    final output = await getTextUseCase(params.audio.textId);
    int numberWords;
    if (output.isRight()) {
      final MyText text = output.getOrElse(() => null);
      numberWords = text.body.split(" ").length;
    } 

    final Duration audioDuration = params.audio.audioDuration;
    final double result = numberWords / audioDuration.inMinutes;
    return Right(result);
  }
}

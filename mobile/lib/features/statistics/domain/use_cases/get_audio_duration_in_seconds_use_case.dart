import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';

class GetAudioDurationInMinutesUseCase implements UseCase<int, AudioParams> {
  @override
  Future<Either<Failure, int>> call(AudioParams params) async {
    final AudioEntity audio = params.audio;
    return Right(audio.audioData.length);
  }
}

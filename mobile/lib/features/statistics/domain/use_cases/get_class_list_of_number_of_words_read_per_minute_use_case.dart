import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_class_use_case.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';

class GetClassListOfNumberOfWordsReadPerMinuteUseCase
    implements UseCase<List<double>, ClassroomParams> {
  final GetAllAudiosFromClassUseCase getAllAudiosFromClassUseCase;
  final GetNumberOfWordsReadPerMinuteUseCase
      getNumberOfWordsReadPerMinuteUseCase;

  GetClassListOfNumberOfWordsReadPerMinuteUseCase(
      {@required this.getAllAudiosFromClassUseCase,
      @required this.getNumberOfWordsReadPerMinuteUseCase});

  @override
  Future<Either<Failure, List<double>>> call(ClassroomParams params) async {
    try {
      List<AudioEntity> audioList = await _getAudiolist(params);

      List<double> numWordReadPerMinute = [];
      for (var i = 0; i < audioList.length; i++) {
        double localNumWordReadPerMinute = await _getStatistic(audioList[i]);
        numWordReadPerMinute.add(localNumWordReadPerMinute);
      }
      return Right(numWordReadPerMinute);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<double> _getStatistic(AudioEntity audio) async {
    final AudioParams audioParams = AudioParams(audio: audio);
    double localNumWordReadPerMinute;
    final statisticOutput =
        await getNumberOfWordsReadPerMinuteUseCase(audioParams);
    statisticOutput.fold((l) {
      throw Exception();
    }, (r) {
      localNumWordReadPerMinute = r;
    });
    return localNumWordReadPerMinute;
  }

  Future<List<AudioEntity>> _getAudiolist(ClassroomParams params) async {
    final audioOutput = await getAllAudiosFromClassUseCase(params);
    List<AudioEntity> audioList;
    audioOutput.fold((l) {
      throw Exception();
    }, (r) {
      audioList = r;
    });
    return audioList;
  }
}

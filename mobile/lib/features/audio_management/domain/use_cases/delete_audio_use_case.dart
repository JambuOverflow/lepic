import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import '../../../../core/use_cases/use_case.dart';
import '../repositories/audio_repository.dart';
import 'audio_params.dart';

class DeleteAudio implements UseCase<void, AudioParams> {
  final AudioRepository repository;

  DeleteAudio({@required this.repository});

  @override
  Future<Either<Failure, void>> call(AudioParams params) =>
      repository.deleteAudio(params.audio);
}

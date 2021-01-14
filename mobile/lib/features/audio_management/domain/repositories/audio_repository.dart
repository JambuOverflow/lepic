import 'package:dartz/dartz.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import '../../../../core/error/failures.dart';

abstract class AudioRepository {
  Future<Either<Failure, AudioEntity>> createAudio(AudioEntity audio);
  Future<Either<Failure, AudioEntity>> updateAudio(AudioEntity audio);
  Future<Either<Failure, AudioEntity>> getAudio({
    Student student,
    MyText text,
  });
  Future<Either<Failure, void>> deleteAudio(AudioEntity audio);
}

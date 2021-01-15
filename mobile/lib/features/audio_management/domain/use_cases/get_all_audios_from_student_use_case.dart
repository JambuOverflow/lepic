import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/repositories/audio_repository.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';


class GetAllAudiosFromStudent implements UseCase<List<AudioEntity>, StudentParams> {
  final AudioRepository repository;

  GetAllAudiosFromStudent({@required this.repository});

  @override
  Future<Either<Failure, List<AudioEntity>>> call(
    StudentParams params,
  ) =>
      repository.getAllAudiosFromStudent(params.student);
}

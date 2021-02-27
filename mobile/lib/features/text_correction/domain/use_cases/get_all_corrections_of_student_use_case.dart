import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';

class GetAllCorrectionsOfStudentUseCase
    implements UseCase<List<Correction>, StudentParams> {
  final CorrectionRepository repository;

  GetAllCorrectionsOfStudentUseCase({@required this.repository});

  @override
  Future<Either<Failure, List<Correction>>> call(
    StudentParams studentParams
  ) =>
      repository.getAllCorrectionsOfStudent(studentParams.student);
}
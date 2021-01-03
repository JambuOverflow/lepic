import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/entities/correction.dart';
import 'package:mobile/features/text_correction/domain/repositories/correction_repository.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

class GetCorrection
    implements UseCase<Correction, StudentTextParams> {
  final CorrectionRepository repository;

  GetCorrection({@required this.repository});

  @override
  Future<Either<Failure, Correction>> call(
    StudentTextParams studentTextParams
  ) =>
      repository.getCorrection(
        text: studentTextParams.text, student: studentTextParams.student,
      );
}

class StudentTextParams extends Equatable {
  final MyText text;
  final Student student;

  StudentTextParams({@required this.text, @required this.student});

  @override
  List<Object> get props => [text, student];
}

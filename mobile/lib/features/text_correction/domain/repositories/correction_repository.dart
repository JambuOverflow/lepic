import 'package:dartz/dartz.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import '../../../../core/error/failures.dart';
import '../entities/correction.dart';

abstract class CorrectionRepository {
  Future<Either<Failure, Correction>> addCorrection(Correction correction);
  Future<Either<Failure, Correction>> updateCorrection(Correction correction);
  Future<Either<Failure, Correction>> getCorrection(MyText text, Student student);
  Future<Either<Failure, Correction>> deleteCorrection(Correction classroom);
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/classroom.dart';

abstract class ClassroomRepository {
  Future<Either<Failure, Classroom>> createClassroom(Classroom classroom);
  Future<Either<Failure, Classroom>> updateClassroom(Classroom classroom);
  Future<Either<Failure, List<Classroom>>> getClassrooms();
  Future<Either<Failure, void>> deleteClassroom(Classroom classroom);
}

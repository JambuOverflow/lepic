import 'package:dartz/dartz.dart';
import '../../../../core/network/response.dart';
import '../../../user_management/domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../entities/classroom.dart';

abstract class ClassroomRepository {
  Future<Either<Failure, Response>> createClassroom(Classroom classroom);
  Future<Either<Failure, Response>> updateClassroom(Classroom classroom);
  Future<Either<Failure, List<Classroom>>> getClassrooms(User user);
  Future<Either<Failure, Response>> deleteClassroom(Classroom classroom);
}

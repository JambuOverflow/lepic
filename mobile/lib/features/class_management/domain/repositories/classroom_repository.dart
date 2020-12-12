import 'package:dartz/dartz.dart';
import '../../../user_management/domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../entities/classroom.dart';
import 'package:http/http.dart' as http;

abstract class ClassroomRepository {
  Future<Either<Failure, Classroom>> createClassroom(Classroom classroom);
  Future<Either<Failure, Classroom>> updateClassroom(Classroom classroom);
  Future<Either<Failure, List<Classroom>>> getClassrooms(User user);
  Future<Either<Failure, void>> deleteClassroom(Classroom classroom);
}

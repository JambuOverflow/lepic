import 'package:dartz/dartz.dart';
import '../../../user_management/domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../entities/school.dart';

abstract class SchoolRepository {
  Future<Either<Failure, School>> createSchool(School classroom);
  Future<Either<Failure, School>> updateSchool(School classroom);
  Future<Either<Failure, List<School>>> getSchools(User user);
  Future<Either<Failure, void>> deleteSchool(School school);
}

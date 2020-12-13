import 'package:dartz/dartz.dart';
import '../entities/student.dart';
import '../../../../core/error/failures.dart';
import '../../../class_management/domain/entities/classroom.dart';

abstract class StudentRepository {
  Future<Either<Failure, Student>> createStudent(Student student);
  Future<Either<Failure, Student>> updateStudent(Student student);
  Future<Either<Failure, List<Student>>> getStudents(Classroom classroom);
  Future<Either<Failure, void>> deleteStudent(Student student);
}

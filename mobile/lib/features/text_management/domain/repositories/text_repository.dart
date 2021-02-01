import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/failures.dart';

import '../../../student_management/domain/entities/student.dart';
import '../entities/text.dart';

abstract class TextRepository {
  Future<Either<Failure, MyText>> createText(MyText text);
  Future<Either<Failure, MyText>> updateText(MyText text);
  Future<Either<Failure, List<MyText>>> getAllUserTexts();
  Future<Either<Failure, List<MyText>>> getStudentTexts(Student student);
  Future<Either<Failure, void>> deleteText(MyText text);
  Future<Either<Failure, MyText>> getTextByID(int id);
}

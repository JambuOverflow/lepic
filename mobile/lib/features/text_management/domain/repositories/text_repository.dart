import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

abstract class TextRepository {
  Future<Either<Failure, MyText>> createText(MyText text);
  Future<Either<Failure, MyText>> updateText(MyText text);
  Future<Either<Failure, List<MyText>>> getAllTextsOfUser();
  Future<Either<Failure, List<MyText>>> getTextsOfClassroom(
      Classroom classroom);
  Future<Either<Failure, void>> deleteText(MyText text);
}

import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';

abstract class TextRepository {
  Future<Either<Failure, Text>> createText(Text text);
  Future<Either<Failure, Text>> updateText(Text text);
  Future<Either<Failure, List<Text>>> getTexts(Classroom classroom);
  Future<Either<Failure, void>> deleteText(Text text);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classroom_from_id_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_zscore_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_student_from_id_use_case.dart';
import 'package:mobile/features/text_correction/domain/use_cases/correction_params.dart';
import 'package:stats/stats.dart';

class GetZscoreOfCorrectNumberOfWordsReadPerMinuteUseCase
    implements UseCase<ReadingStatus, CorrectionParams> {
  final GetClassListOfCorrectNumberOfWordsReadPerMinuteUseCase
      getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase;
  final GetClassroomFromId getClassroomFromId;
  final GetStudentFromId getStudentFromId;
  final GetNumberOfCorrectWordsReadPerMinuteUseCase
      getNumberOfCorrectWordsReadPerMinuteUseCase;

  GetZscoreOfCorrectNumberOfWordsReadPerMinuteUseCase({
    @required this.getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase,
    @required this.getClassroomFromId,
    @required this.getStudentFromId,
    @required this.getNumberOfCorrectWordsReadPerMinuteUseCase,
  });

  @override
  Future<Either<Failure, ReadingStatus>> call(CorrectionParams params) async {
    try {
      final double studentStatistic = await _getStudentStatistic(params);
      Student student = await _getStudent(params);
      final Classroom classroom = await _getClassroom(student);
      List<double> numberOfWordsReadPerMinute =
          await _getClassroomStatistic(classroom);
      
      if (numberOfWordsReadPerMinute.length < 2) {
        return Left(EmptyDataFailure());
      }

      final stats = Stats.fromData(numberOfWordsReadPerMinute);
      final double mean = stats.average;
      final double standardDevation = stats.standardDeviation;

      final double zScore = (studentStatistic - mean) / standardDevation;

      ReadingStatus result;

      if (zScore <= -2.0) {
        result = ReadingStatus.majorDeficit;
      } else if (zScore <= -1.6) {
        result = ReadingStatus.moderateDeficit;
      } else if (zScore <= -1.5) {
        result = ReadingStatus.deficit;
      } else if (zScore <= -1.0) {
        result = ReadingStatus.deficitAlert;
      } else {
        result = ReadingStatus.noDeficit;
      }
      return Right(result);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<double> _getStudentStatistic(CorrectionParams params) async {
    final studentStatiscOutput =
        await getNumberOfCorrectWordsReadPerMinuteUseCase(params);
    double studentStatistic;
    studentStatiscOutput.fold((l) {
      throw Exception();
    }, (r) => {studentStatistic = r});
    return studentStatistic;
  }

  Future<Student> _getStudent(CorrectionParams params) async {
    final studentOutput = await getStudentFromId(params.correction.studentId);
    Student student;
    studentOutput.fold((l) {
      throw Exception();
    }, (r) {
      student = r;
    });
    return student;
  }

  Future<List<double>> _getClassroomStatistic(Classroom classroom) async {
    final ClassroomParams classroomParams =
        ClassroomParams(classroom: classroom);
    List<double> numberOfWordsReadPerMinute;
    final statisticOutput =
        await getClassListOfCorrectNumberOfWordsReadPerMinuteUseCase(classroomParams);
    statisticOutput.fold((l) {
      throw Exception();
    }, (r) {
      numberOfWordsReadPerMinute = r;
    });
    return numberOfWordsReadPerMinute;
  }

  Future<Classroom> _getClassroom(Student student) async {
    final classroomOutput = await getClassroomFromId(student.classroomId);
    Classroom classroom;
    classroomOutput.fold((l) {
      throw Exception();
    }, (r) {
      classroom = r;
    });
    return classroom;
  }
}



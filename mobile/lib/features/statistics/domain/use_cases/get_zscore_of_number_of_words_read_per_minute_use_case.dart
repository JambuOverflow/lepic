import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/class_management/domain/use_cases/get_classroom_from_id_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_class_list_of_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/statistics/domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_student_from_id_use_case.dart';
import 'package:stats/stats.dart';

class GetZscoreOfNumberOfWordsReadPerMinuteUseCase
    implements UseCase<ReadingStatus, AudioParams> {
  final GetClassListOfNumberOfWordsReadPerMinuteUseCase
      getClassListOfNumberOfWordsReadPerMinuteUseCase;
  final GetClassroomFromId getClassroomFromId;
  final GetStudentFromId getStudentFromId;
  final GetNumberOfWordsReadPerMinuteUseCase
      getNumberOfWordsReadPerMinuteUseCase;

  GetZscoreOfNumberOfWordsReadPerMinuteUseCase({
    @required this.getClassListOfNumberOfWordsReadPerMinuteUseCase,
    @required this.getClassroomFromId,
    @required this.getStudentFromId,
    @required this.getNumberOfWordsReadPerMinuteUseCase,
  });

  @override
  Future<Either<Failure, ReadingStatus>> call(AudioParams params) async {
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

  Future<double> _getStudentStatistic(AudioParams params) async {
    final studentStatiscOutput =
        await getNumberOfWordsReadPerMinuteUseCase(params);
    double studentStatistic;
    studentStatiscOutput.fold((l) {
      throw Exception();
    }, (r) => {studentStatistic = r});
    return studentStatistic;
  }

  Future<Student> _getStudent(AudioParams params) async {
    final studentOutput = await getStudentFromId(params.audio.studentId);
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
        await getClassListOfNumberOfWordsReadPerMinuteUseCase(classroomParams);
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

enum ReadingStatus {
  deficitAlert,
  noDeficit,
  moderateDeficit,
  majorDeficit,
  deficit,
}

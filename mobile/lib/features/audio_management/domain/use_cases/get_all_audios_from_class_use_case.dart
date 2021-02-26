import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/use_cases/use_case.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/class_management/domain/use_cases/classroom_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_all_audios_from_student_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/student_management/domain/use_cases/get_students_use_case.dart';
import 'package:mobile/features/student_management/domain/use_cases/student_params.dart';

class GetAllAudiosFromClassUseCase
    implements UseCase<List<AudioEntity>, ClassroomParams> {
  final GetAllAudiosFromStudentUseCase getAllAudiosFromStudentUseCase;
  final GetStudents getStudents;

  GetAllAudiosFromClassUseCase({
    @required this.getAllAudiosFromStudentUseCase,
    @required this.getStudents,
  });

  @override
  Future<Either<Failure, List<AudioEntity>>> call(
    ClassroomParams params,
  ) async {
    try {
      List<Student> students = await _getStudents(params);

      List<AudioEntity> audios = [];
      for (var i = 0; i < students.length; i++) {
        final Student student = students[i];
        final List<AudioEntity> localAudios =
            await _getLocalAudios(student);
        audios = audios + localAudios;
      }
      return Right(audios);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<List<AudioEntity>> _getLocalAudios(Student student) async {
    final StudentParams studentParams = StudentParams(student: student);
    List<AudioEntity> localAudios;

    final audiosOutput = await getAllAudiosFromStudentUseCase(studentParams);
    audiosOutput.fold((l) {
      throw Exception();
    }, (r) {
      localAudios = r;
    });
    return localAudios;
  }

  Future<List<Student>> _getStudents(ClassroomParams params) async {
    final getStudentsOutput = await getStudents(params);
    List<Student> students;
    getStudentsOutput.fold((l) {
      throw Exception();
    }, (r) {
      students = r;
    });
    return students;
  }
}

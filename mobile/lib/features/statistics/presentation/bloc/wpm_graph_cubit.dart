import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../class_management/domain/entities/classroom.dart';
import '../../../class_management/domain/use_cases/classroom_params.dart';
import '../../../class_management/domain/use_cases/get_classroom_from_id_use_case.dart';
import '../../domain/use_cases/get_number_of_correct_words_read_per_minute_use_case.dart';
import '../../domain/use_cases/get_zscore_intervals_of_correct_number_of_words_read_per_minute_use_case.dart';
import '../../domain/use_cases/get_zscore_of_number_of_words_read_per_minute_use_case.dart';
import '../../../text_correction/domain/use_cases/correction_params.dart';
import '../../../text_management/domain/use_cases/get_text_use_case.dart';
import '../../../audio_management/domain/entities/audio.dart';
import '../../../audio_management/domain/use_cases/get_audio_from_id_use_case.dart';
import '../../../text_correction/domain/use_cases/get_correction_from_id_use_case.dart';
import '../../../audio_management/domain/use_cases/audio_params.dart';
import '../../domain/use_cases/get_number_of_words_read_per_minute_use_case.dart';
import '../../../student_management/domain/use_cases/student_params.dart';
import '../../../student_management/domain/entities/student.dart';
import '../../../text_correction/domain/use_cases/get_all_corrections_of_student_use_case.dart';
import '../../../text_correction/domain/entities/correction.dart';
import '../../domain/use_cases/get_zscore_intervals_of_number_of_words_read_per_minute_use_case.dart';

part 'wpm_graph_state.dart';

class WPMGraphCubit extends Cubit<LineGraphState> {
  final Student student;

  final GetZscoreIntervalsOfNumberOfWordsReadPerMinuteUseCase
      getZscoreIntervalsOfNumberOfWordsRead;
  final GetNumberOfWordsReadPerMinuteUseCase getNumberOfWordsRead;

  final GetZscoreIntervalsOfCorrectNumberOfWordsReadPerMinuteUseCase
      getZscoreIntervalsOfCorrectWordsReadPerMinute;
  final GetNumberOfCorrectWordsReadPerMinuteUseCase
      getNumberOfCorrectWordsReadPerMinute;

  final GetAllCorrectionsOfStudentUseCase getAllCorrectionsOfStudent;
  final GetAudioFromIdUseCase getAudioFromIdUseCase;
  final GetTextUseCase getTextUseCase;
  final GetClassroomFromId getClassroomFromId;

  bool _errorOcurred = false;

  WPMGraphCubit({
    @required this.student,
    @required this.getClassroomFromId,
    @required this.getTextUseCase,
    @required this.getAudioFromIdUseCase,
    @required this.getAllCorrectionsOfStudent,
    @required this.getNumberOfWordsRead,
    @required this.getZscoreIntervalsOfNumberOfWordsRead,
    @required this.getNumberOfCorrectWordsReadPerMinute,
    @required this.getZscoreIntervalsOfCorrectWordsReadPerMinute,
  }) : super(LineGraphInitial());

  void load() async {
    _errorOcurred = false;
    emit(LineGraphLoading());

    List<Correction> studentCorrections = await _getStudentCorrections();
    if (_errorOcurred) {
      emit(LineGraphError());
      return;
    }

    List<double> wordsReadPerMinuteResults = <double>[];
    List<double> correctWordsReadPerMinuteResults = <double>[];

    Map<DateTime, double> dateToWPM = <DateTime, double>{};
    Map<DateTime, double> dateToCorrectWPM = <DateTime, double>{};

    await Future.forEach(studentCorrections, (correction) async {
      AudioEntity audio = await _getAudio(correction);
      double wpm = await _getWordsReadPerMinute(audio);
      if (_errorOcurred) {
        emit(LineGraphError());
        return;
      }
      double correctWpm = await _getCorrectWordsReadPerMinute(correction);
      DateTime textCreationDate = await _getTextCreationDate(correction);
      if (_errorOcurred) {
        emit(LineGraphError());
        return;
      }

      dateToCorrectWPM[textCreationDate] = correctWpm;
      dateToWPM[textCreationDate] = wpm;
    });

    final sortedDates = dateToWPM.keys.toList()..sort();
    sortedDates.forEach((date) {
      wordsReadPerMinuteResults.add(dateToWPM[date]);
      correctWordsReadPerMinuteResults.add(dateToCorrectWPM[date]);
    });

    Classroom classroom = await _getClassroom();
    if (_errorOcurred) {
      emit(LineGraphError());
      return;
    }

    Map<ReadingStatus, double> wpmToReadingStatus =
        await _getZScoreIntervalsWPM(classroom);
    if (_errorOcurred) {
      emit(LineGraphError());
      return;
    }

    Map<ReadingStatus, double> correctWpmToReadingStatus =
        await _getZScoreIntervalsCorrectWPM(classroom);
    if (_errorOcurred) {
      emit(LineGraphError());
      return;
    }

    emit(LineGraphLoaded(
      correctWordsReadPerMinuteResults: correctWordsReadPerMinuteResults,
      wordsReadPerMinuteResults: wordsReadPerMinuteResults,
      wpmToReadingStatus: wpmToReadingStatus,
      correctWpmToReadingStatus: correctWpmToReadingStatus,
    ));
  }

  Future<Map<ReadingStatus, double>> _getZScoreIntervalsWPM(
      Classroom classroom) async {
    final successOrFailure = await getZscoreIntervalsOfNumberOfWordsRead(
      ClassroomParams(classroom: classroom),
    );

    Map<ReadingStatus, double> resultToReadingStatus;
    successOrFailure.fold(
      (l) => _errorOcurred = true,
      (interval) => resultToReadingStatus = interval,
    );
    return resultToReadingStatus;
  }

  Future<Map<ReadingStatus, double>> _getZScoreIntervalsCorrectWPM(
      Classroom classroom) async {
    final successOrFailure =
        await getZscoreIntervalsOfCorrectWordsReadPerMinute(
      ClassroomParams(classroom: classroom),
    );

    Map<ReadingStatus, double> resultToReadingStatus;
    successOrFailure.fold(
      (l) => _errorOcurred = true,
      (interval) => resultToReadingStatus = interval,
    );
    return resultToReadingStatus;
  }

  Future<Classroom> _getClassroom() async {
    final classroomOrFailure = await getClassroomFromId(student.classroomId);

    Classroom classroom;
    classroomOrFailure.fold(
      (l) => _errorOcurred = true,
      (classroomGot) => classroom = classroomGot,
    );
    return classroom;
  }

  Future<DateTime> _getTextCreationDate(correction) async {
    final textOrFailure = await getTextUseCase(correction.textId);

    DateTime textCreationDate;
    textOrFailure.fold(
      (l) => _errorOcurred = true,
      (text) => textCreationDate = text.creationDate,
    );
    return textCreationDate;
  }

  Future<double> _getWordsReadPerMinute(AudioEntity audio) async {
    final resultOrFailure = await getNumberOfWordsRead(
      AudioParams(audio: audio),
    );

    double result;
    resultOrFailure.fold(
      (l) => _errorOcurred = true,
      (resultGot) => result = resultGot,
    );
    return result;
  }

  Future<double> _getCorrectWordsReadPerMinute(Correction correction) async {
    final resultOrFailure = await getNumberOfCorrectWordsReadPerMinute(
      CorrectionParams(correction: correction),
    );

    double result;
    resultOrFailure.fold(
      (l) => _errorOcurred = true,
      (resultGot) => result = resultGot,
    );
    return result;
  }

  Future<AudioEntity> _getAudio(correction) async {
    final audioOrFailure = await getAudioFromIdUseCase(
      CorrectionIdParams(
        studentId: correction.studentId,
        textId: correction.textId,
      ),
    );

    AudioEntity audio;
    audioOrFailure.fold(
      (l) => _errorOcurred = true,
      (audioResult) => audio = audioResult,
    );
    return audio;
  }

  Future<List<Correction>> _getStudentCorrections() async {
    final allCorrectionOrFailure = await getAllCorrectionsOfStudent(
      StudentParams(student: student),
    );

    List<Correction> studentCorrections;
    allCorrectionOrFailure.fold(
      (l) => _errorOcurred = true,
      (correctionsGot) => studentCorrections = correctionsGot,
    );
    return studentCorrections;
  }
}

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/features/audio_management/domain/entities/audio.dart';
import 'package:mobile/features/audio_management/domain/use_cases/audio_params.dart';
import 'package:mobile/features/audio_management/domain/use_cases/create_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/delete_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/get_audio_use_case.dart';
import 'package:mobile/features/audio_management/domain/use_cases/update_audio_use_case.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'package:mobile/features/text_correction/domain/use_cases/get_correction_use_case.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:moor/moor.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioEntity audio;

  final MyText text;
  final Student student;
  final CreateAudio createAudio;
  final UpdateAudio updateAudio;
  final GetAudio getAudio;
  final DeleteAudio deleteAudio;

  AudioBloc({
    @required this.text,
    @required this.student,
    @required this.createAudio,
    @required this.getAudio,
    @required this.deleteAudio,
    @required this.updateAudio,
  }) : super(AudioLoadInProgress());

  @override
  Stream<AudioState> mapEventToState(
    AudioEvent event,
  ) async* {
    if (event is CreateAudioEvent)
      yield* _createNewAudioState(event);
    else if (event is UpdateAudioEvent)
      yield* _updateAudioState(event);
    else if (event is DeleteAudioEvent)
      yield* _deleteAudioState(event);
    else if (event is GetAudioEvent) yield* _getAudioState(event);
  }

  Stream<AudioState> _createNewAudioState(CreateAudioEvent event) async* {
    final audio = AudioEntity(
      title: event.title,
      audioData: event.audioData,
      studentId: student.id,
      textId: text.localId,
    );

    final failureOrSucess = await createAudio(AudioParams(audio: audio));

    yield* _eitherLoadedOrErrorState(failureOrSucess);
  }

  Stream<AudioState> _eitherLoadedOrErrorState(
    Either<Failure, dynamic> failureOrSucess,
  ) async* {
    yield* failureOrSucess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(failure));
      },
      (_) async* {
        yield* _loadAndReplaceStudentText();
      },
    );
  }

  Stream<AudioState> _updateAudioState(UpdateAudioEvent event) async* {
    final updatedAudio = AudioEntity(
      title: event.title,
      audioData: event.audioData,
      localId: event.oldAudio.localId,
      studentId: student.id,
      textId: text.localId,
    );

    final failureOrAudio = await updateAudio(AudioParams(audio: updatedAudio));

    yield* _eitherLoadedOrErrorState(failureOrAudio);
  }

  Stream<AudioState> _deleteAudioState(DeleteAudioEvent event) async* {
    final failureOrSuccess = await deleteAudio(AudioParams(audio: event.audio));

    yield* failureOrSuccess.fold(
      (failure) async* {
        yield Error(message: _mapFailureToMessage(CacheFailure()));
      },
      (_) async* {
        yield* _loadAndReplaceStudentText();
      },
    );
  }

  Stream<AudioState> _getAudioState(GetAudioEvent event) async* {
    yield AudioLoadInProgress();

    yield* _loadAndReplaceStudentText();
  }

  Stream<AudioState> _loadAndReplaceStudentText() async* {
    final failureOrAudio = await getAudio(
      StudentTextParams(student: student, text: text),
    );

    yield failureOrAudio.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (audio) {
        this.audio = audio;

        return AudioLoaded(audio: audio);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Could not reach server';
      default:
        return 'Unexpected Error';
    }
  }
}

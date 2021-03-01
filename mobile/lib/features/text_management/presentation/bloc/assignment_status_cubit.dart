import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';
import 'text_bloc.dart';

enum AssignmentStatus {
  loading,
  waiting_audio,
  waiting_correction,
  waiting_report,
  invalid,
}

class AssignmentStatusCubit extends Cubit<AssignmentStatus> {
  final AudioBloc audioBloc;
  final TextBloc textBloc;
  final CorrectionBloc correctionBloc;

  bool get hasCorrectionFinished =>
      state.index > AssignmentStatus.waiting_correction.index;

  AssignmentStatusCubit({
    @required this.audioBloc,
    @required this.textBloc,
    @required this.correctionBloc,
  }) : super(AssignmentStatus.loading) {
    audioBloc.add(LoadAudioEvent());
    audioBloc.listen((_) => _emitStatus());

    correctionBloc.add(LoadCorrectionEvent());
    correctionBloc.listen((state) {
      if (state is CorrectionLoaded) _emitStatus();
    });
  }

  void _emitStatus() async {
    if (!audioBloc.isAudioAttached)
      emit(AssignmentStatus.waiting_audio);
    else if (audioBloc.isAudioAttached && !correctionBloc.hasCorrection)
      emit(AssignmentStatus.waiting_correction);
    else if (correctionBloc.state is CorrectionLoaded &&
        correctionBloc.hasCorrection)
      emit(AssignmentStatus.waiting_report);
    else
      emit(AssignmentStatus.invalid);
  }
}

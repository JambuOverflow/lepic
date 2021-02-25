part of 'correction_bloc.dart';

abstract class CorrectionState extends Equatable {
  const CorrectionState();

  @override
  List<Object> get props => [];
}

class CorrectionLoading extends CorrectionState {}

class CorrectionInProgress extends CorrectionState {
  final Correction correction;

  CorrectionInProgress(this.correction);

  @override
  List<Object> get props => [correction];
}

class CorrectionLoaded extends CorrectionState {
  final Correction correction;

  CorrectionLoaded(this.correction);

  @override
  List<Object> get props => [correction];
}

class CorrectionLoadingError extends CorrectionState {}

class CorrectionDeletionError extends CorrectionState {}

part of 'correction_bloc.dart';

abstract class CorrectionEvent extends Equatable {
  const CorrectionEvent();

  @override
  List<Object> get props => [];
}

class LoadCorrectionEvent extends CorrectionEvent {}

class HighlightEvent extends CorrectionEvent {
  final int wordIndex;

  HighlightEvent({@required this.wordIndex});
}

class CommentEvent extends CorrectionEvent {
  final int wordIndex;
  final String commentary;

  CommentEvent({@required this.wordIndex, @required this.commentary});
}

class RemoveMistakeEvent extends CorrectionEvent {
  final int wordIndex;

  RemoveMistakeEvent({@required this.wordIndex});
}

class FinishCorrectionEvent extends CorrectionEvent {}

class UpdateCorrectionEvent extends CorrectionEvent {}

class DeleteCorrectionEvent extends CorrectionEvent {}

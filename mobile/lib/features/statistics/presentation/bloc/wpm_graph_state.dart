part of 'wpm_graph_cubit.dart';

abstract class LineGraphState extends Equatable {
  const LineGraphState();

  @override
  List<Object> get props => [];
}

class LineGraphInitial extends LineGraphState {}

class LineGraphError extends LineGraphState {}

class LineGraphLoading extends LineGraphState {}

class LineGraphLoaded extends LineGraphState {
  final List<double> wordsReadPerMinuteResults;
  final List<double> correctWordsReadPerMinuteResults;
  final Map<ReadingStatus, double> wpmToReadingStatus;
  final Map<ReadingStatus, double> correctWpmToReadingStatus;

  LineGraphLoaded({
    @required this.wordsReadPerMinuteResults,
    @required this.correctWordsReadPerMinuteResults,
    @required this.wpmToReadingStatus,
    @required this.correctWpmToReadingStatus,
  });
}

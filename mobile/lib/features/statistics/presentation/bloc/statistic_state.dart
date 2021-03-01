part of 'statistic_bloc.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

class StatisticLoading extends StatisticState {}

class StatisticsLoaded extends StatisticState {}

class Error extends StatisticState {
  final String message;

  Error({@required this.message});
}

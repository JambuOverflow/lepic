part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();
}

class AppStarted extends BottomNavigationState {
  @override
  List<Object> get props => [];
}

class CurrentPageIndexChanged extends BottomNavigationState {
  final int currentPageIndex;
  final String pageRouteName;

  CurrentPageIndexChanged({
    @required this.pageRouteName,
    @required this.currentPageIndex,
  });

  @override
  List<Object> get props => [currentPageIndex];
}

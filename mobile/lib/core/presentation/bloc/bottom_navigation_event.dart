part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();
}

class PageTapped extends BottomNavigationEvent {
  final int pageIndex;

  PageTapped({@required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

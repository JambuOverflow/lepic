import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  int _currentPageIndex = 0;
  get currentPageIndex => _currentPageIndex;

  BottomNavigationBloc() : super(AppStarted());

  @override
  Stream<BottomNavigationState> mapEventToState(
    BottomNavigationEvent event,
  ) async* {
    if (event is PageTapped) {
      _currentPageIndex = event.pageIndex;
      yield CurrentPageIndexChanged(
        currentPageIndex: _currentPageIndex,
        pageRouteName: _indexToPageRouteName[_currentPageIndex],
      );
    }
  }

  final _indexToPageRouteName = {
    0: "/home",
    1: "/list_classes",
    2: "/list_students",
    3: "/account",
  };
}

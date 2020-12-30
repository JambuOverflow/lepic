import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/presentation/bloc/bottom_navigation_bloc.dart';

void main() {
  BottomNavigationBloc bottomNavigationBloc;

  setUp(() {
    bottomNavigationBloc = BottomNavigationBloc();
  });

  blocTest(
    'should initiate with [AppStarted]',
    build: () => bottomNavigationBloc,
    verify: (bloc) => bloc.state is AppStarted,
  );

  blocTest(
    'should emit [CurrentPageIndexChanged] with correct index and route name',
    build: () => bottomNavigationBloc,
    act: (bloc) => bloc.add(PageTapped(pageIndex: 1)),
    verify: (bloc) => bloc.currentPageIndex == 1,
    expect: [
      CurrentPageIndexChanged(
        pageRouteName: '/list_classes',
        currentPageIndex: 1,
      )
    ],
  );
}

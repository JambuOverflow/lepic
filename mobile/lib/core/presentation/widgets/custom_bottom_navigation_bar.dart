import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bottom_navigation_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBloc = BlocProvider.of<BottomNavigationBloc>(context);

    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: bottomNavigationBloc.currentPageIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home_rounded),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.group_rounded),
              icon: Icon(Icons.group_outlined),
              label: 'Classrooms',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.text_format_rounded),
              icon: Icon(Icons.text_format_outlined),
              label: 'Texts',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            return bottomNavigationBloc.add(PageTapped(pageIndex: index));
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 6,
        );
      },
    );
  }
}

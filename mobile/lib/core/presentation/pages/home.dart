import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../features/class_management/presentation/bloc/classroom_bloc.dart';
import 'account_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/home_preview.dart';
import '../../../features/class_management/presentation/pages/classrooms_page.dart';
import '../bloc/bottom_navigation_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBloc = BlocProvider.of<BottomNavigationBloc>(context);

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          if (bottomNavigationBloc.state is CurrentPageIndexChanged) {
            switch (bottomNavigationBloc.currentPageIndex) {
              case 0:
                return BlocProvider<ClassroomBloc>(
                  create: (_) => GetIt.instance<ClassroomBloc>(),
                  child: ClassroomsPage(),
                );
              case 1:
                return AccountPage();
              default:
                return BlocProvider<ClassroomBloc>(
                  create: (_) => GetIt.instance<ClassroomBloc>(),
                  child: ClassroomsPage(),
                );
            }
          } else {
            return HomePreview();
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      // drawer: DrawerOverlay(),
    );
  }
}

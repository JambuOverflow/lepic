import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/flight_shuttle_builder.dart';
import 'package:mobile/features/class_management/domain/entities/classroom.dart';

enum MenuOption { Assign, Edit, Remove }

class ClassroomDetailPage extends StatelessWidget {
  final Classroom classroom;

  const ClassroomDetailPage({Key key, this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Class Details'),
      //   actions: <Widget>[
      //     PopupMenuButton<MenuOption>(
      //       onSelected: (MenuOption result) {
      //         if (result == MenuOption.Assign) {
      //           Navigator.of(context).pushNamed(
      //             '/list_texts',
      //           );
      //         } else if (result == MenuOption.Edit) {
      //           Navigator.of(context).pushNamed(
      //             '/update_class',
      //           );
      //         } else if (result == MenuOption.Remove) {
      //           Scaffold.of(context).showSnackBar(
      //             SnackBar(
      //               content:
      //                   Text('Are you sure you want to remove this class?'),
      //             ),
      //           );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return <PopupMenuEntry<MenuOption>>[
      //           PopupMenuItem(
      //             child: Text('Assign student'),
      //             value: MenuOption.Assign,
      //           ),
      //           PopupMenuItem(
      //             child: Text('Edit class'),
      //             value: MenuOption.Edit,
      //           ),
      //           PopupMenuItem(
      //             child: Text('Remove class'),
      //             value: MenuOption.Remove,
      //           ),
      //         ];
      //       },
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Hero(
                tag: classroom.id,
                flightShuttleBuilder: flightShuttleBuilder,
                child: Text(
                  'Class: Vitor Cantinho',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Hero(
                  tag: classroom.grade,
                  flightShuttleBuilder: flightShuttleBuilder,
                  child: Text(
                    'Grade: ${classroom.grade}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

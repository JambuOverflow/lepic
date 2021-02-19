import 'package:flutter/material.dart';
import 'package:mobile/core/presentation/widgets/background_app_bar.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';

class StatisticsPage extends StatelessWidget {
  final Student _student;
  final String _content;

  const StatisticsPage(
      {Key key, @required Student student, @required String content})
      : _student = student,
        _content = content,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackgroundAppBar(title: 'Statistics'),
      body: Scrollbar(
        child: Hero(
          tag: '${_student.id}_body',
          child: Text(_content),
        ),
      ),
    );
  }
}

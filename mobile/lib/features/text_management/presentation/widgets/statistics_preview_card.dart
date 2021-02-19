import 'package:flutter/material.dart';
import 'package:mobile/features/statistics/presentation/pages/statistics_page.dart';
import 'package:mobile/features/student_management/domain/entities/student.dart';
import 'preview_card.dart';

class StatisticsPreviewCard extends StatelessWidget {
  const StatisticsPreviewCard({
    Key key,
    @required Student student,
  })  : _student = student,
        super(key: key);

  final Student _student;

  @override
  Widget build(BuildContext context) {
    final String content =
        '${_student.firstName} ${_student.lastName} had his/her fluency assessed in DATE. He/She read the text in X minutes and Y seconds with Z% of correctness.';
    return PreviewCard(
      title: 'STATISTICS',
      content: [
        buildTextPreviewArea(context, content),
        buildButtons(context),
      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            child: Text('SEE MORE'),
            onPressed: () => navigateToDetails(context),
          ),
        ],
      ),
    );
  }

  Padding buildTextPreviewArea(BuildContext context, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.blue[100].withOpacity(0.5),
        highlightColor: Colors.blue[100].withAlpha(0),
        onTap: () => navigateToDetails(context),
        child: Hero(
          tag: '${_student.id}_body',
          child: Text(
            content,
            maxLines: 6,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void navigateToDetails(BuildContext context) {
    print('navigate');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StatisticsPage(student: _student, content: ),
      ),
    );
  }
}

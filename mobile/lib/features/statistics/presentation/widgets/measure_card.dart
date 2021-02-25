import 'package:flutter/material.dart';

class MeasureCard extends StatelessWidget {
  final String measure;
  final String result;

  const MeasureCard({
    Key key,
    @required this.measure,
    @required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              measure,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(result),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final bool enabled;
  final bool includeTitle;
  final Color titleBackgroundColor;
  final Color titleColor;
  final String title;
  final List<Widget> content;

  const InfoCard({
    Key key,
    this.titleBackgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.includeTitle = true,
    @required this.title,
    @required this.content,
    @required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: enabled ? 4 : 0,
      child: Column(
        children: [
          if (includeTitle) buildTitleBar(),
          ...content,
        ],
      ),
    );
  }

  Container buildTitleBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: titleBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.white,
              iconSize: 16,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

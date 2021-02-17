import 'package:flutter/material.dart';
import 'package:mobile/features/text_management/presentation/widgets/preview_card.dart';

class AudioPreviewCard extends StatelessWidget {
  const AudioPreviewCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      title: null,
      includeTitle: false,
      content: [
        Stack(children: [
          Image.asset(
            "assets/images/no-audio.png",
            height: 75,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Center(
              child: Text(
                'STUDENT\'S RECORDING',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'NO AUDIO ATTACHED',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).disabledColor,
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/pages/audio_page.dart';

import '../../../audio_management/presentation/bloc/audio_bloc.dart';
import 'preview_card.dart';

class AudioPreviewCard extends StatelessWidget {
  const AudioPreviewCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return BlocProvider.of<AudioBloc>(context).isAudioAttached
            ? _AvailableAudioCard()
            : _UnavailableAudioCard();
      },
    );
  }
}

class _AvailableAudioCard extends StatelessWidget {
  const _AvailableAudioCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      title: 'AUDIO',
      content: [
        InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<AudioBloc>(context),
              child: AudioPage(),
            ),
          ),
          child: Container(height: 50),
        ),
      ],
    );
  }
}

class _UnavailableAudioCard extends StatelessWidget {
  const _UnavailableAudioCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: false,
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

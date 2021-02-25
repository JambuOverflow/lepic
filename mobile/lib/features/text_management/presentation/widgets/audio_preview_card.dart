import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../../../audio_management/presentation/pages/audio_page.dart';
import '../../../audio_management/presentation/widgets/audio_preview_player.dart';
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
      titleBackgroundColor: Colors.black87,
      titleColor: Colors.white,
      title: 'AUDIO',
      content: [
        InkWell(
          onTap: () => openBottomSheet(context),
          child: BlocBuilder<PlayerCubit, PlayerState>(
            builder: (context, state) {
              final playerBloc = BlocProvider.of<PlayerCubit>(context);
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.black87),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: AudioPreviewPlayer(playerBloc: playerBloc),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          child: Text('EDIT'),
                          onPressed: () => openBottomSheet(context),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: BlocProvider.of<AudioBloc>(context),
          ),
          BlocProvider.value(
            value: BlocProvider.of<PlayerCubit>(context),
          ),
        ],
        child: AudioPage(),
      ),
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

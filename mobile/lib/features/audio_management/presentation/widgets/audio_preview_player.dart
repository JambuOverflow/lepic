import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/audio_progress_bar.dart';
import '../../../text_correction/presentation/widgets/audio_text_progress_indicator.dart';
import '../bloc/player_cubit.dart';

class AudioPreviewPlayer extends StatelessWidget {
  const AudioPreviewPlayer({
    Key key,
    @required this.playerBloc,
  }) : super(key: key);

  final PlayerCubit playerBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            state is PlayerPlaying
                ? IconButton(
                    icon: Icon(Icons.stop),
                    color: Colors.white,
                    onPressed: () => playerBloc.pause(),
                    iconSize: 35,
                  )
                : IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    color: Colors.white,
                    onPressed: () => playerBloc.play(),
                    iconSize: 35,
                  ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AudioTextProgressIndicator(
                    audioPosition: playerBloc.formattedPosition(),
                    audioDuration: playerBloc.formattedDuration(),
                  ),
                  SizedBox(height: 8),
                  AudioProgressBar(
                    progress: playerBloc.progressPercentage(),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(width: 8),
          ],
        );
      },
    );
  }
}

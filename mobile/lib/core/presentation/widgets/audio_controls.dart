import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/audio_management/presentation/bloc/player_cubit.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerCubit = BlocProvider.of<PlayerCubit>(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.replay_5),
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: () => playerCubit.backwards(seconds: 5),
          ),
          BlocBuilder<PlayerCubit, PlayerState>(
            builder: (context, state) {
              return IconButton(
                iconSize: 40,
                icon: state is PlayerPlaying
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
                color: Colors.white,
                disabledColor: Colors.grey,
                onPressed: () {
                  if (state is PlayerPlaying)
                    playerCubit.pause();
                  else if (state is PlayerPaused)
                    playerCubit.resume();
                  else
                    playerCubit.play();
                },
              );
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.forward_5),
            color: Colors.white,
            disabledColor: Colors.grey,
            onPressed: () => playerCubit.forward(seconds: 5),
          ),
        ],
      ),
    );
  }
}

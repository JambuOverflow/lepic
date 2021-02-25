import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audio_management/presentation/bloc/player_cubit.dart';

import '../../../../core/presentation/widgets/audio_controls.dart';
import '../../../../core/presentation/widgets/audio_progress_bar.dart';
import 'audio_text_progress_indicator.dart';

class AudioSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  bool shouldRebuild(AudioSliverAppBarDelegate oldDelegate) => false;

  @override
  double get maxExtent => 180;
  @override
  double get minExtent => 140;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    final playerCubit = BlocProvider.of<PlayerCubit>(context);

    return SingleChildScrollView(
      // This corrects the overflow caused by shrinking
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            return Column(
              children: [
                AudioTextProgressIndicator(
                  audioDuration: playerCubit.formattedDuration(),
                  audioPosition: playerCubit.formattedPosition(),
                ),
                SizedBox(height: 8),
                AudioProgressBar(progress: playerCubit.progressPercentage()),
                SizedBox(height: 16),
                AudioControls(),
                SizedBox(height: 16),
                Text('More Info', style: TextStyle(color: Colors.white)),
              ],
            );
          },
        ),
      ),
    );
  }
}

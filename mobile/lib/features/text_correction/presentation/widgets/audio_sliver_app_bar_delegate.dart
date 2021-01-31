import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      // This corrects the overflow caused by shrinking
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          children: [
            AudioTextProgressIndicator(),
            SizedBox(height: 8),
            AudioProgressBar(),
            SizedBox(height: 16),
            AudioControls(),
            SizedBox(height: 16),
            Text('More Info', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

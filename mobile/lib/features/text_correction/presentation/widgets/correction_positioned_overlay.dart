import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/correction_bloc.dart';
import 'correction_floating_buttons.dart';

class CorrectionPositionedOverlay extends StatelessWidget {
  const CorrectionPositionedOverlay({
    Key key,
    @required this.wordIndex,
    @required this.entry,
    @required this.offset,
    @required this.deviceSize,
    @required this.horizontalLimit,
    @required this.parentContext,
  }) : super(key: key);

  final int wordIndex;
  final OverlayEntry entry;
  final Offset offset;
  final Size deviceSize;
  final double horizontalLimit;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => entry?.remove(),
        ),
        AlignPositioned(
          dx: (offset.dx - (deviceSize.width * 0.45))
              .clamp(-horizontalLimit / 2.15, horizontalLimit / 2.15),
          dy: offset.dy - (deviceSize.height * 0.495),
          moveByChildHeight: -0.575,
          alignment: Alignment.center,
          child: BlocProvider.value(
            value: BlocProvider.of<CorrectionBloc>(parentContext),
            child: CorrectionFloatingButtons(
              wordIndex: wordIndex,
              entry: entry,
              ancestorContext: parentContext,
            ),
          ),
        ),
      ],
    );
  }
}

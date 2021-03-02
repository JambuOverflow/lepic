import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/assignment_status_cubit.dart';

class AudioStatusText extends StatelessWidget {
  const AudioStatusText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
      builder: (_, state) {
        return Row(
          children: [
            SizedBox(width: 15),
            Icon(
                state == AssignmentStatus.waiting_audio
                    ? Icons.mic_off_outlined
                    : Icons.mic_none,
                size: 16,
                color: Colors.white70),
            SizedBox(width: 6),
            Text(
                state == AssignmentStatus.waiting_audio
                    ? 'No Audio Available'
                    : 'Audio Received',
                style: TextStyle(color: Colors.white70)),
          ],
        );
      },
    );
  }
}

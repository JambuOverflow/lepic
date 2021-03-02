import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/presentation/bloc/assignment_status_cubit.dart';

class CorrectionStatusText extends StatelessWidget {
  const CorrectionStatusText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
      builder: (_, state) {
        return Row(
          children: [
            SizedBox(width: 15),
            Icon(Icons.rate_review_outlined, size: 16, color: Colors.white70),
            SizedBox(width: 6),
            Text(
                state == AssignmentStatus.waiting_correction
                    ? 'Correction in Progress'
                    : 'Correction Complete',
                style: TextStyle(color: Colors.white70)),
          ],
        );
      },
    );
  }
}

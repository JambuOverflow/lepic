import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/bloc/assignment_status_cubit.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

import 'audio_status_text.dart';
import 'correction_status_text.dart';

class TextItemTitle extends StatefulWidget {
  final int index;
  const TextItemTitle({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  _TextItemTitleState createState() => _TextItemTitleState();
}

class _TextItemTitleState extends State<TextItemTitle> {
  @override
  Widget build(BuildContext context) {
    final text = BlocProvider.of<TextBloc>(context).texts[widget.index];
    final date = _getFormattedDate(text);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.black87),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AssignmentStatusCubit, AssignmentStatus>(
            builder: (_, state) {
              return ListTile(
                visualDensity: VisualDensity(vertical: -1.5),
                dense: true,
                title: Text(
                  date,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                subtitle: Text(
                  text.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                    (state != AssignmentStatus.waiting_audio &&
                            state != AssignmentStatus.waiting_correction)
                        ? Icons.check_circle_outline
                        : Icons.timelapse,
                    size: 28,
                    color: Colors.white),
              );
            },
          ),
          AudioStatusText(),
          CorrectionStatusText(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _getFormattedDate(MyText text) {
    return DateFormat('dd/MM/yyyy').format(text.creationDate);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/text_management/presentation/widgets/preview_card.dart';

import '../../../text_correction/presentation/pages/correction_page.dart';
import '../../../text_correction/domain/use_cases/get_correction_use_case.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';

class CorrectionPreviewCard extends StatelessWidget {
  final StudentTextParams params;

  const CorrectionPreviewCard({
    Key key,
    @required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      title: 'READING CORRECTION',
      content: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      GetIt.instance.get<CorrectionBloc>(param1: params),
                  child: CorrectionPage(),
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Image.asset(
                    'assets/images/highlight-disabled.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
          ),
        ),
      ],
    );
  }
}

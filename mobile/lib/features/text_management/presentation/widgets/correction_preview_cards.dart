import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'preview_card.dart';
import '../../../text_correction/presentation/pages/correction_view_page.dart';
import '../../../text_correction/presentation/bloc/correction_bloc.dart';

class CorrectionPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CorrectionBloc>(context);

    return BlocBuilder<CorrectionBloc, CorrectionState>(
      builder: (context, state) {
        return bloc.hasCorrection
            ? _AvailableCorrectionCard(
                bloc: bloc,
              )
            : _UnavailableCorrectionCard(bloc: bloc);
      },
    );
  }
}

class _UnavailableCorrectionCard extends StatelessWidget {
  const _UnavailableCorrectionCard({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final CorrectionBloc bloc;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: false,
      title: 'READING CORRECTION',
      titleBackgroundColor: Colors.black87,
      titleColor: Colors.white,
      content: [
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Column(
            children: [
              _CardTitle(enabled: false),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'UNAVAILABLE',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvailableCorrectionCard extends StatelessWidget {
  const _AvailableCorrectionCard({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final CorrectionBloc bloc;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      enabled: true,
      titleBackgroundColor: Colors.black87,
      titleColor: Colors.white,
      title: 'READING CORRECTION',
      content: [
        InkWell(
          onTap: () => navigateToCorrectionViewPage(context),
          child: Column(
            children: [
              _CardTitle(enabled: true),
              buildButtons(context),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            child: Text('VIEW'),
            onPressed: () => navigateToCorrectionViewPage(context),
          ),
        ],
      ),
    );
  }

  Future navigateToCorrectionViewPage(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<CorrectionBloc>(context),
          child: CorrectionViewPage(),
        ),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final bool enabled;

  const _CardTitle({
    Key key,
    @required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black87),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Image.asset(
          enabled
              ? 'assets/images/highlight.png'
              : 'assets/images/highlight-disabled.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

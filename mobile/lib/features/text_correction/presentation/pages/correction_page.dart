import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/correction_bloc.dart';
import '../widgets/back_confirmation_dialog.dart';
import '../widgets/audio_sliver_app_bar_delegate.dart';
import 'package:mobile/features/text_correction/presentation/widgets/done_confirmation_dialog.dart';
import '../../../text_management/presentation/pages/text_mistake.dart';

class CorrectionPage extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog(
        context: context,
        child: BackConfirmationDialog(),
      ),
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        body: CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(),
            _buildSliverPersistentHeader(),
            _buildSliverList(),
          ],
          controller: _scrollController,
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.done),
      elevation: 6,
      onPressed: () => showDialog(
          context: context,
          child: BlocProvider.value(
            value: BlocProvider.of<CorrectionBloc>(context),
            child: DoneConfirmationDialog(),
          )),
    );
  }

  SliverPersistentHeader _buildSliverPersistentHeader() {
    return SliverPersistentHeader(
      delegate: AudioSliverAppBarDelegate(),
      pinned: true,
    );
  }

  SliverList _buildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),
        TextMistake(),
      ]),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      title: Text(
        'Correcting Joãozinho e o Pé de Feijão',
        overflow: TextOverflow.fade,
      ),
      elevation: 0,
      backgroundColor: Colors.black,
    );
  }
}

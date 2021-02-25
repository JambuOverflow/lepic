import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_management/presentation/bloc/player_cubit.dart';
import '../bloc/correction_bloc.dart';
import '../widgets/back_confirmation_dialog.dart';
import '../widgets/audio_sliver_app_bar_delegate.dart';
import 'package:mobile/features/text_correction/presentation/widgets/done_confirmation_dialog.dart';
import '../widgets/text_mistake.dart';

class CorrectionPage extends StatefulWidget {
  @override
  _CorrectionPageState createState() => _CorrectionPageState();
}

class _CorrectionPageState extends State<CorrectionPage> {
  final _scrollController = ScrollController();
  CorrectionBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<CorrectionBloc>(context);
    bloc.add(LoadCorrectionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<PlayerCubit>(context).stop();
        return showDialog(
          context: context,
          child: BlocProvider.value(
            value: bloc,
            child: BackConfirmationDialog(),
          ),
        );
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
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

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.done),
      elevation: 6,
      onPressed: () {
        BlocProvider.of<PlayerCubit>(context).stop();
        return showDialog(
          context: context,
          child: BlocProvider.value(
            value: bloc,
            child: DoneConfirmationDialog(),
          ),
        );
      },
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
        'Correcting ${bloc.text.title}',
        overflow: TextOverflow.fade,
      ),
      elevation: 0,
      backgroundColor: Colors.black,
    );
  }
}

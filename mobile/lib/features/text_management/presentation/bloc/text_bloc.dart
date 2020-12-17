import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'text_event.dart';
part 'text_state.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  TextBloc() : super(TextNotLoaded());

  @override
  Stream<TextState> mapEventToState(
    TextEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

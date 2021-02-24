import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/text_management/domain/entities/text.dart';
import 'package:mobile/features/text_management/presentation/bloc/text_bloc.dart';

class SingleTextCubit extends Cubit<MyText> {
  final TextBloc textBloc;
  final int assignmentIndex;

  SingleTextCubit({
    @required this.textBloc,
    @required this.assignmentIndex,
  }) : super(textBloc.texts[assignmentIndex]) {
    textBloc.listen((_) => emit(textBloc.texts[assignmentIndex]));
  }
}
